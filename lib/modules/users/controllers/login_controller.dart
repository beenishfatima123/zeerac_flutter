import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/dio_networking/api_response.dart';
import 'package:zeerac_flutter/dio_networking/api_route.dart';
import 'package:zeerac_flutter/modules/users/models/firebase_user_model.dart';
import 'package:zeerac_flutter/modules/users/models/user_model.dart';
import 'package:zeerac_flutter/modules/users/models/user_login_response_model.dart';
import 'package:zeerac_flutter/modules/users/pages/dashboard/dashboard_page.dart';
import 'package:zeerac_flutter/utils/app_pop_ups.dart';
import 'package:zeerac_flutter/utils/firebase_auth_service.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../../../dio_networking/api_client.dart';
import '../../../my_application.dart';
import '../../../utils/user_defaults.dart';
import '../models/property_listing_model.dart';
import 'dart:async';
import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  var isLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  final isObscure = true.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String emailForSocial = '';
  String passwordForSocial = '';

  login(
      {required completion,
      required String email,
      String provider = '',
      required String password}) async {
    isLoading.value = true;

    Map<String, dynamic> body;
    if (provider.isEmpty) {
      body = {
        "email": email,
        "password": password,
      };
    } else {
      body = {"email": email, "u_uid": password, "provider": provider};
    }

    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            needToAuthenticate: false,
            route: APIRoute(
              APIType.loginUser,
              body: body,
            ),
            create: () => APIResponse<UserLoginResponseModel>(
                create: () => UserLoginResponseModel()),
            apiFunction: login)
        .then((response) {
      UserLoginResponseModel? userLoginResponseModel = response.response?.data;
      if (userLoginResponseModel != null) {
        UserDefaults.setApiToken(userLoginResponseModel.token ?? '');

        ///getting user detail from different api
        _getUserDetails(
            id: userLoginResponseModel.id.toString(),
            onComplete: (UserModel user) {
              UserDefaults.saveUserSession(user);
              isLoading.value = false;
              completion(userLoginResponseModel);
            });
      }
    }).catchError((error) {
      isLoading.value = false;
      AppPopUps.showDialogContent(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);
      return Future.value(null);
    });
  }

  void _getUserDetails({required String id, required onComplete}) {
    String url = "${ApiConstants.baseUrl}${ApiConstants.users}${id}/";
    Map<String, dynamic> body = {};
    var client = APIClient(isCache: false, baseUrl: url);
    client
        .request(
            route: APIRoute(
              APIType.loadUserDetails,
              body: body,
            ),
            create: () => APIResponse<UserModel>(create: () => UserModel()),
            apiFunction: _getUserDetails)
        .then((response) {
      if (response.response != null) {
        onComplete(response.response?.data!);
      }
    }).catchError((error) {
      isLoading.value = false;

      ///not showing any dialog because this method will be called on the app start when controller gets initialized

      AppPopUps.showDialogContent(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);

      return Future.value(null);
    });
  }

  void _checkIfEmailAlreadyExists(
      {required String email, required onComplete}) {
    isLoading.value = true;
    Map<String, dynamic> body = {'email': email};
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.checkUniqueMail,
              body: body,
            ),
            create: () => APIResponse(decoding: false),
            apiFunction: _checkIfEmailAlreadyExists)
        .then((response) {
      if (response.response?.responseMessage == 'Email Already Exists') {
        onComplete(true);
      } else {
        onComplete(false);
      }
    }).catchError((error) {
      isLoading.value = false;
      printWrapped(error.toString());

      if ((error.toString() == 'Email Already Exists') ||
          error.toString() == 'More than one account found') {
        onComplete(true);
      } else if (error.toString() == 'No such Email Exists') {
        onComplete(false);
      }
    });
  }

  Future<void> googleLogin() async {
    isLoading.value = true;
    try {
      emailForSocial = '';
      passwordForSocial = '';
      await UserDefaults.clearAll();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential)
          .catchError((onError) {
        printWrapped(onError.toString());
      });

      printWrapped('............Google logged in................');
      authenticationWithCredentials(userCredential);
    } catch (error) {
      printWrapped("...........Error............");
      printWrapped(error.toString());
    }
  }

  Future<void> facebookLogin() async {
    // Trigger the sign-in flow
    isLoading.value = true;
    try {
      emailForSocial = '';
      passwordForSocial = '';
      await UserDefaults.clearAll();
      final LoginResult loginResult =
          await FacebookAuth.instance.login().catchError((onError) {
        printWrapped('............Facebook login error...........');
        printWrapped(onError.toString());
      });
      if (loginResult.accessToken?.token != null) {
        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);

        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
        printWrapped('............Facebook logged in................');

        authenticationWithCredentials(userCredential);
      }
    } catch (error) {
      printWrapped("...........Error............");
      printWrapped(error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  _socialSignUp(
      {required onComplete,
      required String email,
      required String password,
      required String name,
      required String provider}) {
    isLoading.value = true;
    Map<String, dynamic> body = {
      'username': email,
      'email': email,
      'first_name': name,
      'password': password,
      'provider': provider,
    };
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.registerUser,
              body: body,
            ),
            create: () => APIResponse<UserModel>(create: () => UserModel()),
            apiFunction: _socialSignUp)
        .then((response) {
      if (response.response?.data != null) {
        onComplete(response.response!.data!);
      } else {
        AppPopUps.showDialogContent(
            title: 'Error', description: 'Unable to create this user');
      }
    }).catchError((error) {
      isLoading.value = false;
      printWrapped(error.toString());
      AppPopUps.showDialogContent(
          title: 'Error', description: error.toString());
    });
  }

  void authenticationWithCredentials(UserCredential userCredential) {
    printWrapped(userCredential.credential?.providerId ?? '--');
    printWrapped(userCredential.user?.displayName ?? '--');
    printWrapped(userCredential.user?.uid ?? '--');
    printWrapped(userCredential.user?.email ?? '--');
    emailForSocial = (userCredential.user?.email ?? '').trim();
    passwordForSocial = (userCredential.user?.uid ?? '').trim();

    if (emailForSocial.isEmpty || passwordForSocial.isEmpty) {
      isLoading.value = false;
      AppPopUps.showSnackBar(
          message: 'User creation failed', context: myContext!);
      return;
    }

    ///checking if already exists
    _checkIfEmailAlreadyExists(
        email: emailForSocial,
        onComplete: (bool result) async {
          if (result) {
            ///temporary todo
            await FirebaseAuthService.createFireStoreUserEntry(
                userModel: FirebaseUserModel(
                    uid: passwordForSocial,
                    deviceToken:
                        await FirebaseMessaging.instance.getToken() ?? '',
                    isOnline: true,
                    password: passwordForSocial,
                    emailForFirebase: emailForSocial,
                    username: userCredential.user?.displayName ?? ''));

            login(
                email: emailForSocial,
                password: passwordForSocial,
                provider: userCredential.credential?.providerId ?? 'google.com',
                completion: (UserLoginResponseModel? userLoginResponseModel) {
                  Get.offAndToNamed(DashBoardPage.id);
                });
          } else {
            ///signup in rest api database
            _socialSignUp(
                email: emailForSocial,
                password: passwordForSocial,
                name: userCredential.user?.displayName ?? '--',
                provider: userCredential.credential?.providerId ?? 'google.com',
                onComplete: (UserModel userModel) async {
                  ///creating user entry in firebase....
                  await FirebaseAuthService.createFireStoreUserEntry(
                      userModel: FirebaseUserModel(
                          uid: passwordForSocial,
                          emailForFirebase: emailForSocial,
                          password: passwordForSocial,
                          username: userCredential.user?.displayName ?? '--'));

                  ///do login
                  login(
                    email: emailForSocial,
                    password: passwordForSocial,
                    provider:
                        userCredential.credential?.providerId ?? 'google.com',
                    completion:
                        (UserLoginResponseModel? userLoginResponseModel) {
                      Get.offAndToNamed(DashBoardPage.id);
                    },
                  );
                });
          }
        });
  }
}
