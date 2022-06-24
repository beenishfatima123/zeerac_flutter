import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/dio_networking/api_response.dart';
import 'package:zeerac_flutter/dio_networking/api_route.dart';
import 'package:zeerac_flutter/modules/users/models/user_model.dart';
import 'package:zeerac_flutter/modules/users/models/user_login_response_model.dart';
import 'package:zeerac_flutter/utils/app_pop_ups.dart';

import '../../../dio_networking/api_client.dart';
import '../../../my_application.dart';
import '../../../utils/user_defaults.dart';
import '../models/property_listing_model.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  final isObscure = true.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login({required completion}) async {
    isLoading.value = true;
    Map<String, dynamic> body = {
      "email": emailController.text,
      "password": passwordController.text,
    };

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
              completion(response.response?.data);
            });
      }
    }).catchError((error) {
      isLoading.value = false;
      AppPopUps.showDialog(
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

      AppPopUps.showDialog(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);

      return Future.value(null);
    });
  }
}
