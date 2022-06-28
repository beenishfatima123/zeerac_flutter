import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/models/cities_model.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import '../../../../common/app_constants.dart';
import '../../../../common/common_widgets.dart';
import '../../../../common/loading_widget.dart';
import '../../../../dio_networking/app_apis.dart';
import '../../controllers/change_user_preferences_controller.dart';
import '../../models/country_model.dart';
import '../property_listing/property_listing_widgets.dart';

class ChangeUserPreferencesPage extends GetView<ChangeUserPreferenceController>
    with PropertyListingWidgets {
  ChangeUserPreferencesPage({Key? key}) : super(key: key);
  static const id = '/ChangeUserPreferences';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    controller.isLoading.value = false;
    return Scaffold(
      appBar: myAppBar(goBack: true, title: 'User Preference'),
      body: GetX<ChangeUserPreferenceController>(
        initState: (state) {
          controller.getPreferences();
        },
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Expanded(
                            child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              vSpace,
                              Text('Change your preference',
                                  style:
                                      AppTextStyles.textStyleBoldSubTitleLarge),
                              vSpace,

                              ///Property Listing Purpose
                              MyDropDown(
                                suffixIconColor: AppColor.green,
                                borderColor: Colors.transparent,
                                textColor: AppColor.green,
                                labelText: 'Purpose',
                                hintText: 'Select',
                                value: controller.selectedPurpose.value,
                                fillColor: AppColor.alphaGrey,
                                items: AppConstants.purposes,
                                onChange: (value) {
                                  controller.selectedPurpose.value = value;
                                },
                              ),
                              vSpace,

                              ///Property Type
                              MyDropDown(
                                suffixIconColor: AppColor.green,
                                borderColor: Colors.transparent,
                                textColor: AppColor.green,
                                labelText: 'Property Type',
                                hintText: 'Select',
                                fillColor: AppColor.alphaGrey,
                                items: AppConstants.propertiesType,
                                onChange: (value) {
                                  controller.propertyTypeMainValue.value =
                                      value;
                                  controller.changeSelectedPropertyType(value);
                                },
                              ),

                              vSpace,

                              ///Property Type sub

                              Obx(() {
                                return (controller
                                        .propertyTypeMainValue.isNotEmpty)
                                    ? SizedBox(
                                        height: 40,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: AppConstants
                                                .propertiesTypeList[controller
                                                    .activePropertyTypeList
                                                    .value]
                                                .length,
                                            itemBuilder: (context, index) {
                                              String value = AppConstants
                                                      .propertiesTypeList[
                                                  controller
                                                      .activePropertyTypeList
                                                      .value][index];
                                              return Obx(() {
                                                return Container(
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: controller
                                                                .selectedSubPropertyType
                                                                .value ==
                                                            value
                                                        ? AppColor.orangeColor
                                                        : AppColor.alphaGrey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      controller
                                                          .selectedSubPropertyType
                                                          .value = value;
                                                    },
                                                    child: Text(
                                                      value,
                                                      style: AppTextStyles
                                                          .textStyleBoldBodyXSmall
                                                          .copyWith(
                                                              color: AppColor
                                                                  .green),
                                                    ),
                                                  ),
                                                );
                                              });
                                            }),
                                      )
                                    : const IgnorePointer();
                              }),

                              vSpace,

                              ///Property Space Unit
                              MyDropDown(
                                suffixIconColor: AppColor.green,
                                borderColor: Colors.transparent,
                                textColor: AppColor.green,
                                labelText: 'Property Space Unit',
                                hintText: 'Select',
                                fillColor: AppColor.alphaGrey,
                                items: AppConstants.spaceUnits.keys.toList(),
                                onChange: (value) {
                                  controller.selectedSpaceUnit.value = value;
                                },
                              ),

                              vSpace,

                              ///Year Built
                              getTextField(
                                  hintText: 'Property built year',
                                  maxLines: 1,
                                  inputType: TextInputType.number,
                                  controller:
                                      controller.propertyBuiltYearController),

                              vSpace,

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ///country filter

                                    FutureBuilder(
                                        future: controller.getCountriesList(),
                                        builder: (context,
                                            AsyncSnapshot<List<CountryModel>>
                                                snapShot) {
                                          if (snapShot.data != null) {
                                            return DropdownSearch<CountryModel>(
                                              itemAsString: (item) {
                                                return item.name ?? '';
                                              },
                                              selectedItem: controller
                                                  .selectedCountry.value,
                                              clearButtonProps:
                                                  const ClearButtonProps(
                                                      isVisible: true),
                                              dropdownDecoratorProps:
                                                  const DropDownDecoratorProps(
                                                      dropdownSearchDecoration: InputDecoration(
                                                          labelText: 'Country',
                                                          fillColor: AppColor
                                                              .alphaGrey,
                                                          filled: true,
                                                          border:
                                                              InputBorder.none,
                                                          isDense: true)),
                                              popupProps: PopupProps.modalBottomSheet(
                                                  showSearchBox: true,
                                                  isFilterOnline: true,
                                                  searchFieldProps: TextFieldProps(
                                                      decoration:
                                                          const InputDecoration(
                                                              labelText:
                                                                  'search for the country'),
                                                      controller:
                                                          TextEditingController())),
                                              items: snapShot.data!,
                                              validator: (value) {
                                                if (value == null) {
                                                  return 'Required';
                                                }
                                                return null;
                                              },
                                              onChanged: (CountryModel? data) {
                                                controller.selectedCountry
                                                    .value = data;
                                                controller
                                                    .selectedPredictionArea
                                                    .value = null;
                                                controller
                                                    .selectedPredictionCity
                                                    .value = null;
                                              },
                                            );
                                          }
                                          return const IgnorePointer();
                                        }),

                                    vSpace,

                                    ///city filter
                                    DropdownSearch<Predictions>(
                                      itemAsString: (item) {
                                        return item.structuredFormatting
                                                ?.mainText ??
                                            '';
                                      },
                                      selectedItem: controller
                                          .selectedPredictionCity.value,
                                      clearButtonProps: const ClearButtonProps(
                                          isVisible: true),
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Required';
                                        }
                                        return null;
                                      },
                                      dropdownDecoratorProps:
                                          const DropDownDecoratorProps(
                                              dropdownSearchDecoration:
                                                  InputDecoration(
                                                      labelText: 'City',
                                                      fillColor:
                                                          AppColor.alphaGrey,
                                                      filled: true,
                                                      border: InputBorder.none,
                                                      isDense: true)),
                                      popupProps: PopupProps.modalBottomSheet(
                                          showSearchBox: true,
                                          isFilterOnline: true,
                                          searchFieldProps: TextFieldProps(
                                              decoration: const InputDecoration(
                                                  labelText:
                                                      'search for the city'),
                                              controller:
                                                  TextEditingController())),
                                      asyncItems: (String filter) async {
                                        var response = await Dio().get(
                                          "https://maps.googleapis.com/maps/api/place/autocomplete/json?sensor=false&types=(cities)&key=${ApiConstants.googleApiKey}&components=country:${controller.selectedCountry.value?.code ?? 'Pk'.toLowerCase()}",
                                          queryParameters: {"input": filter},
                                        );
                                        var models = CitySuggestions.fromJson(
                                            response.data);

                                        return Future.value(models.predictions);
                                      },
                                      onChanged: (Predictions? data) {
                                        controller.selectedPredictionCity
                                            .value = data;
                                        controller.selectedPredictionArea
                                            .value = null;
                                      },
                                    ),

                                    vSpace,

                                    ///Area filter
                                    DropdownSearch<Predictions>(
                                      itemAsString: (item) {
                                        return item.structuredFormatting
                                                ?.mainText ??
                                            '';
                                      },
                                      selectedItem: controller
                                          .selectedPredictionArea.value,
                                      clearButtonProps: const ClearButtonProps(
                                          isVisible: true),
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Required';
                                        }
                                        return null;
                                      },
                                      dropdownDecoratorProps:
                                          const DropDownDecoratorProps(
                                              dropdownSearchDecoration:
                                                  InputDecoration(
                                                      labelText: 'Area',
                                                      fillColor:
                                                          AppColor.alphaGrey,
                                                      filled: true,
                                                      border: InputBorder.none,
                                                      isDense: true)),
                                      popupProps: PopupProps.modalBottomSheet(
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
                                          "https://maps.googleapis.com/maps/api/place/autocomplete/json?sensor=false&types=(regions)&key=${ApiConstants.googleApiKey}&components=country:${controller.selectedCountry.value?.code ?? 'Pk'.toLowerCase()}",
                                          queryParameters: {
                                            "input": filter,
                                            'location': controller
                                                    .selectedPredictionCity
                                                    .value
                                                    ?.description ??
                                                ''
                                          },
                                        );
                                        var models = CitySuggestions.fromJson(
                                            response.data);

                                        return Future.value(models.predictions);
                                      },
                                      onChanged: (Predictions? data) {
                                        controller.selectedPredictionArea
                                            .value = data;
                                      },
                                    ),

                                    vSpace,
                                  ],
                                ),
                              ),

                              vSpace,

                              ///is newly constructed
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Obx(() {
                                  controller.isNewlyConstructed.value;
                                  return mySwitch(
                                      checkColor: AppColor.green,
                                      fillColor: AppColor.alphaGrey,
                                      onTickTap: () {
                                        controller.isNewlyConstructed.value =
                                            !controller
                                                .isNewlyConstructed.value;
                                      },
                                      onMessageTap: () {
                                        controller.isNewlyConstructed.value =
                                            !controller
                                                .isNewlyConstructed.value;
                                      },
                                      isActive:
                                          controller.isNewlyConstructed.value,
                                      message: 'Newly Constructed',
                                      messageColor: AppColor.primaryBlueColor);
                                }),
                              ),

                              vSpace,

                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Property Price Range",
                                      style: AppTextStyles
                                          .textStyleBoldBodyMedium),
                                  Text(
                                      "Min=${controller.propertyPriceRangeValue.value.start.round().toString()} - Max=${controller.propertyPriceRangeValue.value.end.round().toString()}",
                                      style: AppTextStyles
                                          .textStyleNormalBodyMedium),
                                  RangeSlider(
                                    activeColor: AppColor.primaryBlueColor,
                                    inactiveColor: AppColor.alphaGrey,
                                    min: 0,
                                    max: 1000,
                                    divisions: 10,
                                    labels: RangeLabels(
                                        controller
                                            .propertyPriceRangeValue.value.start
                                            .round()
                                            .toString(),
                                        controller
                                            .propertyPriceRangeValue.value.end
                                            .round()
                                            .toString()),
                                    values: controller
                                        .propertyPriceRangeValue.value,
                                    onChanged: (values) {
                                      controller.propertyPriceRangeValue.value =
                                          values;
                                    },
                                  ),
                                ],
                              ),

                              vSpace,

                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Plot Size",
                                      style: AppTextStyles
                                          .textStyleBoldBodyMedium),
                                  Text(
                                      "Min=${controller.propertyPlotRangeValue.value.start.round().toString()} - Max=${controller.propertyPlotRangeValue.value.end.round().toString()}",
                                      style: AppTextStyles
                                          .textStyleNormalBodyMedium),
                                  RangeSlider(
                                    activeColor: AppColor.primaryBlueColor,
                                    inactiveColor: AppColor.alphaGrey,
                                    min: 0,
                                    max: 1000,
                                    divisions: 10,
                                    labels: RangeLabels(
                                        controller
                                            .propertyPlotRangeValue.value.start
                                            .round()
                                            .toString(),
                                        controller
                                            .propertyPlotRangeValue.value.end
                                            .round()
                                            .toString()),
                                    values:
                                        controller.propertyPlotRangeValue.value,
                                    onChanged: (values) {
                                      controller.propertyPlotRangeValue.value =
                                          values;
                                    },
                                  ),
                                ],
                              ),

                              vSpace,
                            ],
                          ),
                        )),
                        vSpace,
                        Button(
                            buttonText:
                                controller.previousPreferenceValue.value != -1
                                    ? 'Update'
                                    : 'Submit',
                            leftPadding: 50.w,
                            rightPading: 50.w,
                            onTap: () {
                              if ((_formKey.currentState?.validate() ??
                                  false)) {
                                if (controller.previousPreferenceValue.value ==
                                    -1) {
                                  controller.submitPreferences(
                                      completion: () {});
                                } else {
                                  controller.updatePreference(
                                      completion: () {});
                                }
                              }
                            },
                            textColor: AppColor.whiteColor),
                        vSpace,
                      ],
                    ),
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
