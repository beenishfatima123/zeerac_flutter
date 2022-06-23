import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/dio_networking/api_client.dart';
import 'package:zeerac_flutter/dio_networking/api_response.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/my_application.dart';
import 'package:zeerac_flutter/utils/app_pop_ups.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import 'package:zeerac_flutter/utils/user_defaults.dart';

import '../../../dio_networking/api_route.dart';
import '../models/register_user_response_model.dart';

class AddNewAgentController extends GetxController {
  RxBool isLoading = false.obs;

  var formKeyUserInfo = GlobalKey<FormState>();
  Rxn<File?> profileImage = Rxn<File>();

  TextEditingController userNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController areasTextController = TextEditingController();
  TextEditingController addressCityController = TextEditingController();
  TextEditingController addressDescription = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  var isObscure = false.obs;
  var isObscure2 = false.obs;

  void addNewAgentToCompany({required onComplete}) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKeyUserInfo.currentState!.validate()) {
      if (profileImage.value != null) {
        _registerUser(completion: (String userResponseModel) {
          printWrapped("user created success");
          onComplete(userResponseModel);
        });
      } else {
        AppPopUps.showSnackBar(message: "Select Image", context: myContext!);
      }
    }
  }

  Future<void> _registerUser({required completion}) async {
    printWrapped("registering agemt");
    isLoading.value = true;
    var data = dio.FormData.fromMap({
      "photo": await dio.MultipartFile.fromFile(profileImage.value!.path,
          filename: "profileimage.png"),
      "address": addressDescription.text,
      "area": areasTextController.text,
      "city": addressCityController.text,
      "cnic": cnicController.text,
      "email": emailController.text,
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "phone_number": phoneNumberController.text,
      "username": userNameController.text,
      "password": passwordController.text,
      "isAgent": true,
      'admin': UserDefaults.getUserSession()?.id ?? 0
    });
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.registerUser,
              body: data,
            ),
            create: () => APIResponse<RegisterUserResponseModel>(
                create: () => RegisterUserResponseModel()),
            apiFunction: _registerUser)
        .then((response) {
      isLoading.value = false;
      printWrapped(
          "registering user response ${response.response?.data.toString()}");

      if (response.response?.data != null) {
        completion(response.response?.responseMessage ?? '');
      } else {
        AppPopUps.showDialog(
            title: 'Error',
            description: "Failed to register user",
            dialogType: DialogType.ERROR);
      }
    }).catchError((error) {
      print("error in catch");
      isLoading.value = false;
      AppPopUps.showDialog(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);
      return Future.value(null);
    });
  }
}
