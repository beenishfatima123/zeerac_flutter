import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/dio_networking/api_client.dart';
import 'package:zeerac_flutter/dio_networking/api_response.dart';
import 'package:zeerac_flutter/dio_networking/api_route.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/models/cities_model.dart';
import 'package:zeerac_flutter/modules/users/models/user_login_response_model.dart';
import 'package:zeerac_flutter/utils/user_defaults.dart';

import '../../../utils/app_pop_ups.dart';
import '../models/companies_response_model.dart';

class UserProfileController extends GetxController {
  RxBool isLoading = false.obs;
  Rxn<File?> profileImage = Rxn<File>();

  RxString networkImage = ''.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  User? user;

  var selectedCityPrediction = Predictions(description: '').obs;
  var selectedArea = Predictions(description: '').obs;

  void initValues() {
    _getUserDetails(onComplete: (User user) {
      this.user = user;

      networkImage.value = user.photo ?? '';
      emailController.text = user.email ?? '-';
      usernameController.text = user.username ?? '-';
      firstNameController.text = user.firstName ?? '-';
      cnicController.text = user.cnic ?? '-';
      phoneController.text = user.phoneNumber ?? '-';
      countryController.text = user.country ?? '-';
      selectedCityPrediction.value = Predictions(description: user.city);
      selectedArea.value = Predictions(description: user.area ?? '');

      addressController.text = user.address ?? '-';
      emailController.text = user.email ?? '-';
    });
  }

  void updateUser() {}

  void _getUserDetails({required onComplete}) {
    String url =
        "${ApiConstants.baseUrl}${ApiConstants.loadUserDetails}${UserDefaults.getUserSession()?.id}/";
    isLoading.value = true;
    Map<String, dynamic> body = {};
    var client = APIClient(isCache: false, baseUrl: url);
    client
        .request(
            route: APIRoute(
              APIType.loadUserDetails,
              body: body,
            ),
            create: () => APIResponse<User>(create: () => User()),
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
  }
}
