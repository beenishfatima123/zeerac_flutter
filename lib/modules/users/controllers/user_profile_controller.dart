import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/dio_networking/api_client.dart';
import 'package:zeerac_flutter/dio_networking/api_response.dart';
import 'package:zeerac_flutter/dio_networking/api_route.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/models/cities_model.dart';
import 'package:zeerac_flutter/modules/users/models/user_login_response_model.dart';
import 'package:zeerac_flutter/my_application.dart';
import 'package:zeerac_flutter/utils/user_defaults.dart';

import '../../../utils/app_pop_ups.dart';
import '../models/companies_response_model.dart';
import 'package:dio/dio.dart' as dio;

import '../models/user_model.dart';

class UserProfileController extends GetxController {
  RxBool isLoading = false.obs;
  Rxn<File?> profileImage = Rxn<File>();

  RxString networkImage = ''.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  UserModel? user;

  var selectedCityPrediction = Predictions(description: '').obs;
  var selectedArea = Predictions(description: '').obs;

  void initValues() {
    UserModel? user = UserDefaults.getUserSession();
    if (user != null) {
      this.user = user;
      networkImage.value = user.photo ?? '';
      emailController.text = user.email ?? '-';
      usernameController.text = user.username ?? '-';
      firstNameController.text = user.firstName ?? '-';
      lastNameController.text = user.lastName ?? '-';
      cnicController.text = user.cnic ?? '-';
      phoneController.text = user.phoneNumber ?? '-';
      countryController.text = user.country ?? '-';
      selectedCityPrediction.value = Predictions(description: user.city);
      selectedArea.value = Predictions(description: user.area ?? '');
      addressController.text = user.address ?? '-';
      emailController.text = user.email ?? '-';
    }
  }

  Future<void> updateUser({required onComplete}) async {
    String url =
        "${ApiConstants.baseUrl}${ApiConstants.users}/${UserDefaults.getUserSession()?.id}/";
    isLoading.value = true;
    var body = dio.FormData.fromMap(<String, dynamic>{
      'photo': profileImage.value != null
          ? await dio.MultipartFile.fromFile(profileImage.value!.path,
              filename: 'user_image.png')
          : null,
      "username": usernameController.text,
      "email": emailController.text,
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "address": addressController.text,
      "country": countryController.text,
      "cnic": cnicController.text,
      "phone_number": phoneController.text,
      "city": selectedCityPrediction.value.description ?? '-',
      "area": selectedArea.value.description ?? '-',
    });
    var client = APIClient(isCache: false, baseUrl: url);
    client
        .request(
            route: APIRoute(
              APIType.updateUserDetails,
              body: body,
            ),
            create: () => APIResponse<UserModel>(create: () => UserModel()),
            apiFunction: updateUser)
        .then((response) {
      isLoading.value = false;
      UserModel? userModel = response.response?.data;
      if (userModel != null) {
        UserDefaults.saveUserSession(userModel);
        AppPopUps.showSnackBar(
            message: 'Profile updated',
            context: myContext!,
            color: AppColor.green);
      } else {
        AppPopUps.showDialogContent(
            title: 'Failed to update profile',
            description: response.response?.responseMessage ?? '-',
            dialogType: DialogType.ERROR);
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

  /* void _getUserDetails({required onComplete}) {
    String url =
        "${ApiConstants.baseUrl}${ApiConstants.users}${UserDefaults.getUserSession()?.id}/";
    isLoading.value = true;
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
      isLoading.value = false;
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
  }*/
}
