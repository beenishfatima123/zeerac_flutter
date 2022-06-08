import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  RxBool isLoading = false.obs;

  ////.................user information......................///
  var formKeyUserInfo = GlobalKey<FormState>();
  var isObscure = false.obs;
  var isObscure2 = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  Rxn<File?> profileImage = Rxn<File>();

  ////.................address information......................///

  TextEditingController addressCityController = TextEditingController();
  TextEditingController areasTextController = TextEditingController();
  TextEditingController addressDescription = TextEditingController();

  var isSignUpAsAgent = false.obs;

  void clearStates() {
    formKeyUserInfo = GlobalKey<FormState>();
    isLoading.value = false;
    emailController.clear();
  }
}
