import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import 'package:zeerac_flutter/common/languages.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/modules/users/models/firebase_user_model.dart';
import 'package:zeerac_flutter/modules/users/models/user_login_response_model.dart';
import 'package:zeerac_flutter/modules/users/pages/dashboard/dashboard_page.dart';
import 'package:zeerac_flutter/modules/users/pages/sign_up/sign_up_page.dart';
import 'package:zeerac_flutter/my_application.dart';
import 'package:zeerac_flutter/utils/app_pop_ups.dart';
import 'package:zeerac_flutter/utils/extension.dart';
import 'package:zeerac_flutter/utils/firebase_auth_service.dart';
import 'package:zeerac_flutter/utils/user_defaults.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import '../../../../common/common_widgets.dart';
import '../../../../common/loading_widget.dart';
import '../../../../common/styles.dart';
import '../../controllers/login_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends GetView<LoginController> {
  LoginPage({Key? key}) : super(key: key);
  static const id = '/LoginPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(goBack: false, actions: [
        SizedBox(
          width: 120,
          child: MyDropDown(
            leftPadding: 0,
            rightPadding: 0,
            value: Languages.getCurrentLanguageName(),
            textColor: AppColor.blackColor,
            onChange: (value) {
              Languages.updateLocale(value);
            },
            items: Languages.languages,
          ),
        )
      ]),
      body: GetX<LoginController>(initState: (state) {
        controller.emailController.clear();
        controller.passwordController.clear();
        // controller.onInit();
      }, builder: (_) {
        return SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Center(
                                child: Image.asset(
                                  "assets/images/logo.png",
                                  height: 300,
                                  width: 300,
                                ),
                              ),
                            ],
                          ),
                          vSpace,
                          Text(
                            "Login to continue",
                            style: AppTextStyles.textStyleBoldSubTitleLarge,
                          ),
                          vSpace,
                          vSpace,
                          MyTextField(
                              controller: controller.emailController,
                              hintText: "Email",
                              contentPadding: 20 /* context.height * 0.04*/,
                              prefixIcon: "assets/icons/ic_mail.svg",
                              focusBorderColor: AppColor.primaryBlueDarkColor,
                              textColor: AppColor.blackColor,
                              hintColor: AppColor.blackColor,
                              fillColor: AppColor.alphaGrey,
                              validator: (String? value) =>
                                  value!.toValidEmail()),
                          vSpace,
                          Obx(
                            () => MyTextField(
                              controller: controller.passwordController,
                              contentPadding: 20 /* context.height * 0.04*/,
                              suffixIconWidet: GestureDetector(
                                  onTap: () {
                                    controller.isObscure.value =
                                        !controller.isObscure.value;
                                  },
                                  child: Icon(controller.isObscure.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined)),
                              hintText: "Password",
                              prefixIcon: "assets/icons/ic_lock.svg",
                              focusBorderColor: AppColor.primaryBlueDarkColor,
                              textColor: AppColor.blackColor,
                              hintColor: AppColor.blackColor,
                              fillColor: AppColor.alphaGrey,
                              obsecureText: controller.isObscure.value,
                              validator: (String? value) =>
                                  value!.toValidPassword(),
                            ),
                          ),
                          vSpace,
                          vSpace,
                          Button(
                            buttonText: "login".tr,
                            padding: 16 /*context.height * 0.04*/,
                            textColor: AppColor.whiteColor,
                            color: AppColor.primaryBlueDarkColor,
                            onTap: () async {
                              if (controller.formKey.currentState!.validate()) {
                                FocusManager.instance.primaryFocus?.unfocus();

                                bool result = await FirebaseAuthService
                                    .signInWithEmailAndPassword(
                                        controller.emailController.text.trim(),
                                        controller.passwordController.text
                                            .trim());

                                if (result) {
                                  String userId =
                                      FirebaseAuth.instance.currentUser?.uid ??
                                          '';
                                  printWrapped("firebase logged in  $userId");

                                  ///todo temporary
                                  await FirebaseAuthService
                                      .createFireStoreUserEntry(
                                          userModel:
                                              FirebaseUserModel(
                                                  uid: userId,
                                                  deviceToken:
                                                      await FirebaseMessaging
                                                              .instance
                                                              .getToken() ??
                                                          '',
                                                  isOnline: true,
                                                  password:
                                                      controller
                                                          .passwordController
                                                          .text
                                                          .trim(),
                                                  emailForFirebase: controller
                                                      .emailController.text
                                                      .trim(),
                                                  username: 'user_name'));

                                  controller.login(
                                    email:
                                        controller.emailController.text.trim(),
                                    password: controller.passwordController.text
                                        .trim(),
                                    completion: (UserLoginResponseModel?
                                        userLoginResponseModel) {
                                      Get.offAndToNamed(DashBoardPage.id);
                                    },
                                  );
                                }
                              }
                            },
                          ),
                          vSpace,
                          vSpace,
                          vSpace,
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Expanded(
                                    child: Divider(color: AppColor.blackColor)),
                                Flexible(
                                    child: Text(' Or ',
                                        style: AppTextStyles
                                            .textStyleBoldBodyMedium)),
                                const Expanded(
                                    child: Divider(color: AppColor.blackColor)),
                              ]),
                          vSpace,
                          vSpace,
                          SignInButton(
                            buttonType: ButtonType.google,
                            btnText: 'Sign in with google',
                            onPressed: () {
                              controller.googleLogin();
                            },
                          ),
                          vSpace,
                          SignInButton(
                            buttonType: ButtonType.facebook,
                            btnText: 'Sign in with facebook',
                            onPressed: () {
                              controller.facebookLogin();
                            },
                          ),
                          vSpace,
                          vSpace,
                          vSpace,
                          vSpace,
                          vSpace,
                          vSpace,
                          vSpace,
                          vSpace,
                          Text(
                            "Don't have an account?",
                            style: AppTextStyles.textStyleNormalBodyMedium,
                          ),
                          InkWell(
                            onTap: () {
                              Get.offNamed(SignupPage.id);
                            },
                            child: Text(
                              "Sign up",
                              style: AppTextStyles.textStyleBoldBodyMedium
                                  .copyWith(
                                      decoration: TextDecoration.underline,
                                      color: AppColor.primaryBlueColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (controller.isLoading.isTrue) LoadingWidget(),
            ],
          ),
        );
      }),
    );
  }
}
