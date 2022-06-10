import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
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
import 'package:zeerac_flutter/modules/users/pages/login/login_page.dart';
import 'package:zeerac_flutter/my_application.dart';
import 'package:zeerac_flutter/utils/app_pop_ups.dart';
import 'package:zeerac_flutter/utils/extension.dart';
import '../../../../common/languages.dart';
import '../../../../common/loading_widget.dart';
import '../../../../common/spaces_boxes.dart';
import '../../../../utils/app_utils.dart';
import '../../../../utils/helpers.dart';
import '../../controllers/signup_controller.dart';
import '../../models/cities_model.dart';
import 'sign_up_widgets.dart';

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
        controller.clearState();
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
                          child: getImageWidget(controller.profileImage),
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
                            hintText: 'Last name',
                            controller: controller.lastNameController),
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
                              /*MaskTextInputFormatter(
                                  mask: '+## (###) #######',
                                  filter: {"#": RegExp(r'[0-9]')},
                                  type: MaskAutoCompletionType.lazy)*/
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
                                          controller: TextEditingController())),
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
                                    controller.areasTextController.text = '';
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
                                              controller:
                                                  TextEditingController())),
                                  asyncItems: (String filter) async {
                                    var response = await Dio().get(
                                      'https://maps.googleapis.com/maps/api/place/autocomplete/json?sensor=false&types=(regions)&key=AIzaSyC0-5OqwY75sPwoncSujsbkJD6wDU7BvOw&components=country:pk',
                                      queryParameters: {
                                        "input":
                                            " ${controller.addressCityController.text},$filter}"
                                      },
                                    );
                                    var models =
                                        CitySuggestions.fromJson(response.data);
                                    return Future.value(models.predictions);
                                  },
                                  onChanged: (List<Predictions?>? data) {
                                    printWrapped(
                                        "*******on changed called*****");
                                    data?.forEach(
                                      (element) {
                                        String s =
                                            controller.areasTextController.text;
                                        s = "$s,${element?.description ?? 'null'}";
                                        controller.areasTextController.text = s;
                                      },
                                    );
                                    printWrapped(
                                        controller.areasTextController.text);
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
                            message: "Register as agency",
                            isActive: controller.isSignUpAsAgency.value,
                            messageColor: AppColor.blackColor,
                            fillColor: AppColor.primaryBlueColor,
                            checkColor: AppColor.whiteColor,
                            onTap: () {
                              controller.isSignUpAsAgency.value =
                                  !controller.isSignUpAsAgency.value;
                            }),
                        vSpace,
                        if (controller.isSignUpAsAgency.value)
                          showAgencySignupInfoForm(),
                        vSpace,
                        Button(
                          buttonText: "Register".tr,
                          padding: 16,
                          textColor: AppColor.whiteColor,
                          color: AppColor.primaryBlueDarkColor,
                          onTap: () {
                            controller.registerAction(
                                mainCompletion: (String message) {
                              AppPopUps.showDialog(
                                  title: 'Success',
                                  description: message,
                                  dialogType: DialogType.SUCCES);
                            });
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

  showAgencySignupInfoForm() {
    return Form(
      key: controller.agencyInfoFormKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 100.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  vSpace,
                  Text(
                    'Company Information',
                    style: AppTextStyles.textStyleBoldBodyMedium,
                  ),
                  vSpace,
                  Text(
                    'Company logo',
                    style: AppTextStyles.textStyleNormalBodySmall,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () async {
                        AppUtils.showPicker(
                          context: myContext!,
                          onComplete: (File? file) {
                            if (file != null) {
                              controller.agencyLogo.value = file;
                            }
                          },
                        );
                      },
                      child: getImageWidget(controller.agencyLogo),
                    ),
                  ),
                  vSpace,
                ],
              ),
            ),
          ),
          vSpace,
          getTextField(
              hintText: 'Company Name',
              controller: controller.companyNameController),
          vSpace,
          getTextField(
              hintText: 'Company email',
              controller: controller.companyMailController,
              validator: (String? value) {
                return value?.toValidEmail();
              }),
          vSpace,
          getTextField(
              hintText: 'Company Fax',
              controller: controller.companyFaxController),
          vSpace,
          getTextField(
              hintText: 'Company Description',
              controller: controller.companyDescription),
          vSpace,
          vSpace,
          vSpace,
          vSpace,
          vSpace,
          vSpace,
        ],
      ),
    );
  }
}
