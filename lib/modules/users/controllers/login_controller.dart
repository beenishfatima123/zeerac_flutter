import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/dio_networking/api_response.dart';
import 'package:zeerac_flutter/dio_networking/api_route.dart';
import 'package:zeerac_flutter/modules/users/models/user_login_response_model.dart';
import 'package:zeerac_flutter/utils/app_pop_ups.dart';

import '../../../dio_networking/api_client.dart';
import '../../../my_application.dart';
import '../../../utils/user_defaults.dart';

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
            route: APIRoute(
              APIType.loginUser,
              body: body,
            ),
            create: () => APIResponse<UserLoginResponseModel>(
                create: () => UserLoginResponseModel()),
            apiFunction: login)
        .then((response) {
      isLoading.value = false;
      if (response.response?.data?.token != null) {
        UserDefaults.setApiToken(response.response?.data?.token ?? '');
        UserDefaults.saveUserSession(response.response!.data!);
        completion(response.response?.data);
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
}
