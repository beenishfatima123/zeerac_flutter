import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uuid/uuid.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/pages/login_page.dart';
import 'package:zeerac_flutter/utils/extension.dart';
import '../../../common/languages.dart';
import '../../../common/loading_widget.dart';
import '../../../common/spaces_boxes.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/helpers.dart';
import '../controllers/signup_controller.dart';
import '../models/cities_model.dart';

class SignupPage extends GetView<SignupController> {
  const SignupPage({Key? key}) : super(key: key);
  static const id = '/SignupPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'Signup to Zeerac', goBack: false, actions: [
        SizedBox(
          width: 120,
          child: MyDropDown(
            isDense: true,
            value: Languages.getCurrentLanguageName(),
            textColor: AppColor.blackColor,
            onChange: (value) {
              Languages.updateLocale(value);
            },
            items: Languages.languages,
          ),
        )
      ]),
      body: GetX<SignupController>(initState: (state) {
        controller.clearStates();
      }, builder: (_) {
        return SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: Form(
                    key: controller.formKeyUserInfo,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        vSpace,
                        vSpace,
                        GestureDetector(
                          onTap: () async {
                            AppUtils.showPicker(
                              context: context,
                              onComplete: (File? file) {
                                if (file != null) {
                                  controller.profileImage.value = file;
                                }
                              },
                            );
                          },
                          child: getImage(),
                        ),
                        vSpace,
                        vSpace,
                        getTextField(
                            hintText: 'User name',
                            controller: controller.usernameController),
                        vSpace,
                        getTextField(
                            hintText: 'First name',
                            controller: controller.firstNameController),
                        vSpace,
                        getTextField(
                            hintText: 'Email',
                            controller: controller.emailController,
                            validator: (String? value) {
                              return value?.toValidEmail();
                            }),
                        vSpace,
                        getTextField(
                            hintText: 'CNIC xxxx-xxxxxx-x',
                            inputType: TextInputType.number,
                            controller: controller.cnicController,
                            inputFormatters: [
                              MaskTextInputFormatter(
                                  mask: '#####-#######-#',
                                  filter: {"#": RegExp(r'[0-9]')},
                                  type: MaskAutoCompletionType.lazy)
                            ],
                            validator: (String? value) {
                              return value?.toValidateCnic();
                            }),
                        vSpace,
                        getTextField(
                            inputType: TextInputType.phone,
                            hintText: 'Phone +92 (xxx) xxxxxxx',
                            inputFormatters: [
                              MaskTextInputFormatter(
                                  mask: '+## (###) #######',
                                  filter: {"#": RegExp(r'[0-9]')},
                                  type: MaskAutoCompletionType.lazy)
                            ],
                            controller: controller.phoneController),
                        vSpace,
                        Obx(
                          () => MyTextField(
                            controller: controller.passwordController,
                            contentPadding: 20,
                            suffixIconWidet: GestureDetector(
                                onTap: () {
                                  controller.isObscure.value =
                                      !controller.isObscure.value;
                                },
                                child: Icon(controller.isObscure.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined)),
                            hintText: "Password",
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
                        Obx(
                          () => MyTextField(
                              controller: controller.confirmPasswordController,
                              contentPadding: 20,
                              suffixIconWidet: GestureDetector(
                                  onTap: () {
                                    controller.isObscure2.value =
                                        !controller.isObscure2.value;
                                  },
                                  child: Icon(controller.isObscure2.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined)),
                              hintText: "Confirm Password",
                              focusBorderColor: AppColor.primaryBlueDarkColor,
                              textColor: AppColor.blackColor,
                              hintColor: AppColor.blackColor,
                              fillColor: AppColor.alphaGrey,
                              obsecureText: controller.isObscure2.value,
                              validator: (String? value) {
                                if ((value ?? '') !=
                                    controller.passwordController.text) {
                                  return 'Password do not match';
                                }
                                return null;
                              }),
                        ),
                        vSpace,
                        vSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 100.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Address Information',
                                  style: AppTextStyles.textStyleBoldBodyMedium,
                                ),
                                vSpace,
                                DropdownSearch<Predictions>(
                                  itemAsString: (item) {
                                    return item.description ?? '';
                                  },
                                  dropdownDecoratorProps:
                                      const DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                                  labelText: 'City')),
                                  popupProps: PopupProps.bottomSheet(
                                      showSearchBox: true,
                                      isFilterOnline: true,
                                      searchFieldProps: TextFieldProps(
                                          decoration: const InputDecoration(
                                              labelText: 'search for the city'),
                                          controller: controller
                                              .addressCityController)),
                                  asyncItems: (String filter) async {
                                    var response = await Dio().get(
                                      "https://maps.googleapis.com/maps/api/place/autocomplete/json?sensor=false&types=(cities)&key=AIzaSyC0-5OqwY75sPwoncSujsbkJD6wDU7BvOw&components=country:pk",
                                      queryParameters: {"input": filter},
                                    );
                                    var models =
                                        CitySuggestions.fromJson(response.data);
                                    return Future.value(models.predictions);
                                  },
                                  onChanged: (Predictions? data) {
                                    controller.addressCityController.text =
                                        data?.description ?? '';
                                  },
                                ),
                                vSpace,
                                DropdownSearch<Predictions>.multiSelection(
                                  itemAsString: (item) {
                                    return item.description ?? '';
                                  },
                                  dropdownDecoratorProps:
                                      const DropDownDecoratorProps(
                                    dropdownSearchDecoration:
                                        InputDecoration(labelText: 'Area'),
                                  ),
                                  popupProps:
                                      PopupPropsMultiSelection.bottomSheet(
                                          showSearchBox: true,
                                          isFilterOnline: true,
                                          searchFieldProps: TextFieldProps(
                                              decoration: const InputDecoration(
                                                  labelText:
                                                      'search for the area'),
                                              controller: controller
                                                  .areasTextController)),
                                  asyncItems: (String filter) async {
                                    var response = await Dio().get(
                                      'https://maps.googleapis.com/maps/api/place/autocomplete/json?sensor=false&types=(regions)&key=AIzaSyC0-5OqwY75sPwoncSujsbkJD6wDU7BvOw&components=country:pk',
                                      queryParameters: {
                                        "input":
                                            filter /*controller
                                            .addressCityController.text*/
                                      },
                                    );
                                    var models =
                                        CitySuggestions.fromJson(response.data);
                                    return Future.value(models.predictions);
                                  },
                                  onSaved: (List<Predictions?>? data) {
                                    data?.forEach(
                                      (element) {
                                        controller.addressCityController.text =
                                            element?.description ?? 'null';
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        vSpace,
                        getTextField(
                            hintText: 'Address',
                            minLines: 3,
                            maxLines: 5,
                            controller: controller.addressDescription),
                        vSpace,
                        vSpace,
                        vSpace,
                        mySwitch(
                            message: "Register as agent",
                            isActive: controller.isSignUpAsAgent.value,
                            messageColor: AppColor.blackColor,
                            fillColor: AppColor.primaryBlueColor,
                            checkColor: AppColor.whiteColor,
                            onTap: () {
                              controller.isSignUpAsAgent.value =
                                  !controller.isSignUpAsAgent.value;
                            }),
                        vSpace,
                        vSpace,
                        Button(
                          buttonText: "Proceed Next".tr,
                          padding: 16,
                          textColor: AppColor.whiteColor,
                          color: AppColor.primaryBlueDarkColor,
                          onTap: () {
                            if (controller.formKeyUserInfo.currentState!
                                .validate()) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              /*   controller.login(
                                  completion: (UserModel userModel) {});*/
                            }
                          },
                        ),
                        vSpace,
                        vSpace,
                        Text(
                          "Already have an account?",
                          style: AppTextStyles.textStyleNormalBodyMedium,
                        ),
                        InkWell(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Get.offNamed(LoginPage.id);
                          },
                          child: Text(
                            "Sign in",
                            style: AppTextStyles.textStyleBoldBodyMedium
                                .copyWith(
                                    decoration: TextDecoration.underline,
                                    color: AppColor.primaryBlueColor),
                          ),
                        ),
                        vSpace,
                        vSpace,
                        vSpace,
                        vSpace,
                      ],
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

  getTextField(
      {required String hintText,
      required TextEditingController controller,
      String? validateText,
      bool validate = true,
      bool enabled = true,
      int minLines = 1,
      int maxLines = 2,
      List<TextInputFormatter> inputFormatters = const [],
      TextInputType inputType = TextInputType.text,
      validator}) {
    return MyTextField(
        controller: controller,
        enable: enabled,
        hintText: hintText,
        minLines: minLines,
        maxLines: maxLines,
        contentPadding: 20,
        keyboardType: inputType,
        inputFormatters: inputFormatters,
        focusBorderColor: AppColor.primaryBlueDarkColor,
        textColor: AppColor.blackColor,
        hintColor: AppColor.blackColor,
        fillColor: AppColor.alphaGrey,
        validator: validator ??
            (String? value) => validate
                ? (value!.trim().isEmpty ? validateText ?? "Required" : null)
                : null);
  }

  Widget getImage() {
    if (controller.profileImage.value != null) {
      return Stack(
        children: [
          CircleAvatar(
              radius: 70,
              backgroundImage:
                  Image.file(controller.profileImage.value!).image),
        ],
      );
    } else {
      return Stack(
        children: [
          const CircleAvatar(
              radius: 70,
              backgroundImage:
                  AssetImage('assets/images/place_your_image.png')),
          Positioned(
            bottom: 1,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 3,
                    color: Colors.white,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      50,
                    ),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(2, 4),
                      color: Colors.black.withOpacity(
                        0.3,
                      ),
                      blurRadius: 3,
                    ),
                  ]),
              child: const Padding(
                padding: EdgeInsets.all(2.0),
                child: Icon(Icons.add_a_photo, color: Colors.black),
              ),
            ),
          ),
        ],
      );
    }
  }
}
