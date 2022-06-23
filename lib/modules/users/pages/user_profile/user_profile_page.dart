import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/user_profile_controller.dart';
import 'package:zeerac_flutter/modules/users/models/user_login_response_model.dart';
import 'package:zeerac_flutter/modules/users/pages/sign_up/sign_up_widgets.dart';
import 'package:zeerac_flutter/utils/app_utils.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import 'package:zeerac_flutter/utils/user_defaults.dart';
import '../../../../common/loading_widget.dart';
import '../../models/cities_model.dart';

class UserProfilePage extends GetView<UserProfileController>
    with SignupWidgetsMixin {
  UserProfilePage({Key? key}) : super(key: key);
  static const id = '/UserProfilePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(goBack: true, title: 'Profile'),
      body: GetX<UserProfileController>(
        initState: (state) {
          controller.initValues();
        },
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: GestureDetector(
                          onTap: () async {
                            AppUtils.showPicker(
                              context: context,
                              onComplete: (File? file) {
                                if (file != null) {
                                  controller.profileImage.value = file;
                                  controller.networkImage.value = '';
                                } else {
                                  controller.networkImage.value =
                                      controller.user?.photo ?? '';
                                }
                              },
                            );
                          },
                          child: getImageWidget(controller.profileImage,
                              networkImage: controller.networkImage.value),
                        ),
                      ),
                      vSpace,
                      getTextField(
                          hintText: 'User name',
                          controller: controller.usernameController,
                          enabled: false),

                      vSpace,
                      getTextField(
                          hintText: 'Email',
                          controller: controller.emailController,
                          enabled: true),
                      vSpace,
                      getTextField(
                          hintText: 'First name',
                          controller: controller.firstNameController),
                      vSpace,
                      getTextField(
                          hintText: 'Last name',
                          controller: controller.lastNameController,
                          enabled: false),
                      vSpace,
                      getTextField(
                          hintText: 'Address',
                          controller: controller.addressController),
                      vSpace,
                      getTextField(
                          hintText: 'CNIC',
                          controller: controller.cnicController),
                      vSpace,
                      getTextField(
                          hintText: 'Phone number',
                          controller: controller.phoneController),
                      vSpace,
                      getTextField(
                          hintText: 'Country',
                          controller: controller.countryController),
                      vSpace,

                      ///city
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 100.w),
                        child: DropdownSearch<Predictions>(
                          itemAsString: (item) {
                            return item.description ?? '';
                          },
                          selectedItem: controller.selectedCityPrediction.value,
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                              dropdownSearchDecoration:
                                  InputDecoration(labelText: 'City')),
                          popupProps: PopupProps.bottomSheet(
                              showSearchBox: true,
                              isFilterOnline: true,
                              searchFieldProps: TextFieldProps(
                                  decoration: const InputDecoration(
                                      labelText: 'search for the city'),
                                  controller: TextEditingController())),
                          asyncItems: (String filter) async {
                            var response = await Dio().get(
                              "https://maps.googleapis.com/maps/api/place/autocomplete/json?sensor=false&types=(cities)&key=${ApiConstants.googleApiKey}&components=country:pk",
                              queryParameters: {"input": filter},
                            );
                            var models =
                                CitySuggestions.fromJson(response.data);
                            return Future.value(models.predictions);
                          },
                          onChanged: (Predictions? data) {
                            controller.selectedCityPrediction.value = data!;
                          },
                        ),
                      ),
                      vSpace,

                      ///area
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 100.w),
                        child: DropdownSearch<Predictions>(
                          itemAsString: (item) {
                            return item.description ?? '';
                          },
                          selectedItem: controller.selectedArea.value,
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                              dropdownSearchDecoration:
                                  InputDecoration(labelText: 'Area')),
                          popupProps: PopupProps.bottomSheet(
                              showSearchBox: true,
                              isFilterOnline: true,
                              searchFieldProps: TextFieldProps(
                                  decoration: const InputDecoration(
                                      labelText: 'search for the area'),
                                  controller: TextEditingController())),
                          asyncItems: (String filter) async {
                            var response = await Dio().get(
                              "https://maps.googleapis.com/maps/api/place/autocomplete/json?sensor=false&types=(cities)&key=${ApiConstants.googleApiKey}&components=country:pk",
                              queryParameters: {"input": filter},
                            );
                            var models =
                                CitySuggestions.fromJson(response.data);
                            return Future.value(models.predictions);
                          },
                          onChanged: (Predictions? data) {
                            controller.selectedCityPrediction.value = data!;
                          },
                        ),
                      ),
                      vSpace,

                      vSpace,
                      vSpace,
                      Button(
                        padding: 16,
                        leftPadding: 100.w,
                        rightPading: 100.w,
                        textColor: AppColor.whiteColor,
                        color: AppColor.primaryBlueDarkColor,
                        buttonText: 'Update',
                        onTap: () {
                          controller.updateUser(onComplete: () {});
                        },
                      ),
                      vSpace,
                      vSpace,
                    ],
                  ),
                ),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
