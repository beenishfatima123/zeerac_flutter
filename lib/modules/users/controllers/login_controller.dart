import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


class LoginController extends GetxController {
  var loading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  final isObscure = true.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login() {
    loading.value = true;

  }

  void _loginResponse(dynamic value) {
  }

}
