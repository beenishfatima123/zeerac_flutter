import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/dio_networking/api_response.dart';
import 'package:zeerac_flutter/dio_networking/api_route.dart';
import 'package:zeerac_flutter/main.dart';
import 'package:zeerac_flutter/modules/users/models/register_company_response_model.dart';
import 'package:zeerac_flutter/modules/users/models/user_model.dart';
import 'package:zeerac_flutter/my_application.dart';
import 'package:zeerac_flutter/utils/app_pop_ups.dart';
import 'package:zeerac_flutter/utils/helpers.dart';

import '../../../dio_networking/api_client.dart';
import '../models/user_login_response_model.dart';

class SignupController extends GetxController {
  RxBool isLoading = false.obs;

  ////.................user information......................///
  var formKeyUserInfo = GlobalKey<FormState>();
  var isObscure = false.obs;
  var isObscure2 = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  Rxn<File?> profileImage = Rxn<File>();

  ////.................address information......................///

  TextEditingController addressCityController = TextEditingController();
  TextEditingController areasTextController = TextEditingController();
  TextEditingController addressDescription = TextEditingController();

  var isSignUpAsAgency = false.obs;

//...............agency info...............//
  TextEditingController companyNameController = TextEditingController();
  TextEditingController companyMailController = TextEditingController();
  TextEditingController companyFaxController = TextEditingController();
  TextEditingController companyPhoneController = TextEditingController();
  TextEditingController companyDescription = TextEditingController();

  var agencyInfoFormKey = GlobalKey<FormState>();
  Rxn<File?> agencyLogo = Rxn<File>();

  void registerAction({required mainCompletion}) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (isSignUpAsAgency.value) {
      if (agencyInfoFormKey.currentState!.validate() &&
          formKeyUserInfo.currentState!.validate()) {
        if (profileImage.value != null && agencyLogo.value != null) {
          _registerUser(completion: (UserModel responseModel) {
            ///registering company with the response of the register user
            printWrapped("registering company");
            _registerCompany(
                registerUserResponseModel: responseModel,
                completion: (RegisterCompanyResponse registerCompanyResponse) {
                  mainCompletion("Company registered successfully");
                });
          });
        } else {
          AppPopUps.showSnackBar(message: "Select Image", context: myContext!);
        }
      }
    } else {
      if (formKeyUserInfo.currentState!.validate()) {
        if (profileImage.value != null) {
          _registerUser(completion: (UserModel registerUserResponseModel) {
            mainCompletion("User registered successfully");
          });
        } else {
          AppPopUps.showSnackBar(message: "Select Image", context: myContext!);
        }
      }
    }
  }

  Future<void> _registerUser({required completion}) async {
    printWrapped("registering user");
    isLoading.value = true;
    var data = dio.FormData.fromMap({
      "photo": await dio.MultipartFile.fromFile(profileImage.value!.path,
          filename: "profile_image.png"),
      "address": addressDescription.text,
      "area": areasTextController.text,
      "city": addressCityController.text,
      "cnic": cnicController.text,
      "email": emailController.text,
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "phone_number": phoneController.text,
      "username": usernameController.text,
      "password": passwordController.text,
      "isAgent": false
    });
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            needToAuthenticate: false,
            route: APIRoute(
              APIType.registerUser,
              body: data,
            ),
            create: () => APIResponse<UserModel>(create: () => UserModel()),
            apiFunction: _registerUser)
        .then((response) {
      if (!isSignUpAsAgency.value) {
        isLoading.value = false;
      }
      printWrapped(
          "registering user response ${response.response?.data.toString()}");

      if (response.response?.data != null) {
        completion(response.response?.data!);
      } else {
        AppPopUps.showDialog(
            title: 'Error',
            description: "Failed to register user",
            dialogType: DialogType.ERROR);
      }
    }).catchError((error) {
      print(error);

      isLoading.value = false;
      AppPopUps.showDialog(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);
      return Future.value(null);
    });
  }

  void _registerCompany(
      {required UserModel registerUserResponseModel,
      required completion}) async {
    var data = dio.FormData.fromMap({
      "logo": await dio.MultipartFile.fromFile(agencyLogo.value!.path,
          filename: "agencyLogo.png"),
      "name": companyNameController.text,
      "description": companyDescription.text,
      "phone": companyPhoneController.text,
      "fax": companyFaxController.text,
      "address": addressDescription.text,
      "admin": registerUserResponseModel.id,
      "is_active": true,
      "email": companyMailController.text,
    });

    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            needToAuthenticate: false,
            route: APIRoute(
              APIType.registerCompany,
              body: data,
            ),
            create: () => APIResponse<RegisterCompanyResponse>(
                create: () => RegisterCompanyResponse()),
            apiFunction: _registerCompany)
        .then((response) {
      isLoading.value = false;

      printWrapped(
          "registering response ${response.response?.data.toString()}");
      if (response.response?.data != null) {
        completion(response.response?.data!);
      } else {
        AppPopUps.showDialog(
            title: 'Error',
            description: "Failed to register company",
            dialogType: DialogType.ERROR);
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

  void clearState() {}
}
