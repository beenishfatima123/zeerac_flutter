import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/languages.dart';
import 'package:zeerac_flutter/utils/extensions/extension.dart';
import 'package:zeerac_flutter/utils/user_defaults.dart';
import 'package:zeerac_flutter/utils/utils.dart';

import '../../../common/common_widgets.dart';
import '../../../common/loading_widget.dart';
import '../../../common/styles.dart';
import '../controllers/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  LoginPage({Key? key}) : super(key: key);
  static const id = '/LoginPage';
  final vSpace = SizedBox(height: 20.h);
  final hSpace = SizedBox(width: 50.w);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<LoginController>(
          initState: (state) {},
          builder: (_) {
            return SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Center(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Center(
                                  child: Hero(
                                    tag: "logoSigUp",
                                    child: Image.asset(
                                      "assets/images/logo.png",
                                      height: 300,
                                      width: 300,
                                      color: AppColor.blackColor,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    width: 120,
                                    height: 40,
                                    child: MyDropDown(
                                      isDense: true,
                                       value: Languages.getCurrentLanguageName(),
                                      textColor: AppColor.blackColor,
                                      fillColor: AppColor.primaryBlueDarkColor
                                          .withOpacity(0.5),
                                      onChange: (value) {
                                        Languages.updateLocale(value);
                                      },
                                      items: Languages.languages,
                                    ),
                                  ),
                                )
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
                              onTap: () {
                                FocusScope.of(context).unfocus();

                                //     controller.createAdminUser();
                                if (_formKey.currentState!.validate()) {
                                  controller.login();
                                }
                              },
                            ),
                            vSpace,
                            Text(
                              "Don't have an account?",
                              style: AppTextStyles.textStyleNormalBodyMedium,
                            ),
                            InkWell(
                              onTap: () {
                                // Get.off(ChooseSignUpPage());
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
                  if (controller.loading.isTrue) LoadingWidget(),
                ],
              ),
            );
          }),
    );
  }
}
