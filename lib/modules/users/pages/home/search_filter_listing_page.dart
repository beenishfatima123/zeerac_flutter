import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zeerac_flutter/common/app_constants.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/controllers/search_filter_listing_controller.dart';
import 'package:zeerac_flutter/modules/users/models/cities_model.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart';
import 'package:zeerac_flutter/modules/users/pages/property_listing/property_listing_page.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import '../../../../common/common_widgets.dart';
import '../../../../common/loading_widget.dart';

class SearchFilterListingPage extends GetView<SearchFilterListingController> {
  const SearchFilterListingPage({Key? key}) : super(key: key);
  static const id = '/SearchFilterListingPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        goBack: true,
        title: "Apply Filters",
        actions: [
          hSpace,
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Center(
              child: Text(
                'Done',
                style: AppTextStyles.textStyleBoldBodySmall,
              ),
            ),
          ),
          hSpace
        ],
      ),
      body: GetX<SearchFilterListingController>(
        initState: (state) {},
        builder: (_) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(18.h),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///filters
                              ///city filter
                              DropdownSearch<Predictions>(
                                itemAsString: (item) {
                                  return item.structuredFormatting?.mainText ??
                                      '';
                                },
                                selectedItem:
                                    controller.selectedPredictionCity.value,
                                clearButtonProps:
                                    const ClearButtonProps(isVisible: true),
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                        labelText: 'City',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.r),
                                          borderSide: const BorderSide(
                                              color: AppColor.alphaGrey),
                                        ),
                                        isDense: true)),
                                popupProps: PopupProps.modalBottomSheet(
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
                                  controller.selectedPredictionCity.value =
                                      data ?? Predictions();
                                  controller.selectedPredictionArea.value =
                                      Predictions(description: 'Select Area');
                                },
                              ),
                              vSpace,

                              ///Area filter
                              DropdownSearch<Predictions>(
                                itemAsString: (item) {
                                  return item.structuredFormatting?.mainText ??
                                      '';
                                },
                                selectedItem:
                                    controller.selectedPredictionArea.value,
                                clearButtonProps:
                                    const ClearButtonProps(isVisible: true),
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                        labelText: 'Area',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.r),
                                          borderSide: const BorderSide(
                                              color: AppColor.alphaGrey),
                                        ),
                                        isDense: true)),
                                popupProps: PopupProps.modalBottomSheet(
                                    showSearchBox: true,
                                    isFilterOnline: true,
                                    searchFieldProps: TextFieldProps(
                                        decoration: const InputDecoration(
                                            labelText: 'search for the area'),
                                        controller: TextEditingController())),
                                asyncItems: (String filter) async {
                                  var response = await Dio().get(
                                    'https://maps.googleapis.com/maps/api/place/autocomplete/json?sensor=false&types=(regions)&key=${ApiConstants.googleApiKey}&components=country:pk',
                                    queryParameters: {
                                      "input":
                                          '${controller.selectedPredictionCity.value.description},$filter'
                                    },
                                  );
                                  var models =
                                      CitySuggestions.fromJson(response.data);
                                  return Future.value(models.predictions);
                                },
                                onChanged: (Predictions? data) {
                                  controller.selectedPredictionArea.value =
                                      data ?? Predictions();
                                },
                              ),
                              vSpace,

                              ///Locations filter
                              DropdownSearch<Predictions>.multiSelection(
                                itemAsString: (item) {
                                  return item.description ?? '';
                                },
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                      labelText: 'Locations',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.r),
                                        borderSide: const BorderSide(
                                            color: AppColor.alphaGrey),
                                      ),
                                      isDense: true),
                                ),
                                popupProps:
                                    PopupPropsMultiSelection.modalBottomSheet(
                                        showSearchBox: true,
                                        isFilterOnline: true,
                                        searchFieldProps: TextFieldProps(
                                            decoration: InputDecoration(
                                                labelText:
                                                    'search for the locations',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.r),
                                                  borderSide: const BorderSide(
                                                      color:
                                                          AppColor.alphaGrey),
                                                ),
                                                isDense: true),
                                            controller:
                                                TextEditingController())),
                                asyncItems: (String filter) async {
                                  var response = await Dio().get(
                                    'https://maps.googleapis.com/maps/api/place/autocomplete/json?sensor=false&types=(regions)&key=${ApiConstants.googleApiKey}&components=country:pk',
                                    queryParameters: {
                                      // 'radius': 500,
                                      "input": filter,
                                      'location': controller
                                          .selectedPredictionArea
                                          .value
                                          .description
                                    },
                                  );
                                  var models =
                                      CitySuggestions.fromJson(response.data);
                                  print(models);
                                  return Future.value(models.predictions);
                                },
                                onChanged: (List<Predictions?>? data) {
                                  controller.selectedLocationsList = data;
                                },
                              ),

                              ///purpose filter
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Purpose",
                                          style: AppTextStyles
                                              .textStyleBoldBodySmall,
                                        ),
                                      ),
                                      Flexible(
                                        child: MyDropDown(
                                          suffixIconColor: AppColor.green,
                                          borderColor: Colors.transparent,
                                          textColor: AppColor.green,
                                          value:
                                              controller.selectedPurpose.value,
                                          items: AppConstants.purposes,
                                          onChange: (value) {
                                            controller.selectedPurpose.value =
                                                value;
                                          },
                                        ),
                                      )
                                      /*  FlutterSwitch(
                                        width: 70.0,
                                        height: 30.0,
                                        valueFontSize: 15.0,
                                        toggleSize: 30.0,
                                        value: controller.isBuying.value,
                                        borderRadius: 30.0,
                                        padding: 4.0,
                                        activeText: 'Buy',
                                        activeColor: AppColor.green,
                                        inactiveColor: AppColor.greyColor,
                                        inactiveText: 'Rent',
                                        showOnOff: true,
                                        onToggle: (val) {
                                          controller.isBuying.value = val;
                                        },
                                      ),*/
                                    ],
                                  ),
                                  const Divider(color: AppColor.blackColor),
                                  vSpace,
                                ],
                              ),

                              ///Property Type filter
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Property Type",
                                          style: AppTextStyles
                                              .textStyleBoldBodySmall,
                                        ),
                                      ),
                                      Flexible(
                                        child: MyDropDown(
                                          suffixIconColor: AppColor.green,
                                          borderColor: Colors.transparent,
                                          textColor: AppColor.green,
                                          items: AppConstants.propertiesType,
                                          value: controller
                                              .propertyTypeMainValue.value,
                                          onChange: (value) {
                                            controller.propertyTypeMainValue
                                                .value = value;
                                            controller
                                                .changeSelectedPropertyType(
                                                    value);
                                          },
                                        ),
                                      ),

                                      /*  FlutterSwitch(
                                        width: 70.0,
                                        height: 30.0,
                                        valueFontSize: 15.0,
                                        toggleSize: 30.0,
                                        value: controller.isBuying.value,
                                        borderRadius: 30.0,
                                        padding: 4.0,
                                        activeText: 'Buy',
                                        activeColor: AppColor.green,
                                        inactiveColor: AppColor.greyColor,
                                        inactiveText: 'Rent',
                                        showOnOff: true,
                                        onToggle: (val) {
                                          controller.isBuying.value = val;
                                        },
                                      ),*/
                                    ],
                                  ),
                                  SizedBox(
                                    height: 40,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: AppConstants
                                            .propertiesTypeList[controller
                                                .activePropertyTypeList.value]
                                            .length,
                                        itemBuilder: (context, index) {
                                          String value =
                                              AppConstants.propertiesTypeList[
                                                  controller
                                                      .activePropertyTypeList
                                                      .value][index];
                                          return Obx(() {
                                            return Container(
                                              margin: const EdgeInsets.all(5),
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: controller
                                                            .selectedPropertyType
                                                            .value ==
                                                        value
                                                    ? AppColor.orangeColor
                                                    : AppColor.alphaGrey,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  controller
                                                      .selectedPropertyType
                                                      .value = value;
                                                },
                                                child: Text(
                                                  value,
                                                  style: AppTextStyles
                                                      .textStyleBoldBodyXSmall
                                                      .copyWith(
                                                          color:
                                                              AppColor.green),
                                                ),
                                              ),
                                            );
                                          });
                                        }),
                                  ),
                                  const Divider(color: AppColor.blackColor),
                                  vSpace,
                                ],
                              ),

                              ///Beds
                              if (controller.activePropertyTypeList.value != 0)
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Beds",
                                            style: AppTextStyles
                                                .textStyleBoldBodySmall,
                                          ),
                                        ),
                                        Expanded(
                                          child: MyDropDown(
                                            suffixIconColor: AppColor.green,
                                            borderColor: Colors.transparent,
                                            textColor: AppColor.green,
                                            items: AppConstants.beds,
                                            onChange: (value) {
                                              controller.selectedBeds;
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    const Divider(color: AppColor.blackColor),
                                    vSpace,
                                  ],
                                ),

                              ///Baths
                              if (controller.activePropertyTypeList.value != 0)
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Baths",
                                            style: AppTextStyles
                                                .textStyleBoldBodySmall,
                                          ),
                                        ),
                                        Expanded(
                                          child: MyDropDown(
                                            suffixIconColor: AppColor.green,
                                            borderColor: Colors.transparent,
                                            textColor: AppColor.green,
                                            items: AppConstants.baths,
                                            onChange: (value) {
                                              controller.selectedBaths;
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    const Divider(color: AppColor.blackColor),
                                    vSpace,
                                  ],
                                ),

                              ///keywords
                              vSpace,
                              Text(
                                'Search with keywords',
                                style: AppTextStyles.textStyleBoldBodyMedium,
                              ),

                              DropdownSearch<String>.multiSelection(
                                itemAsString: (item) {
                                  return item;
                                },
                                dropdownDecoratorProps:
                                    const DropDownDecoratorProps(
                                  dropdownSearchDecoration:
                                      InputDecoration(labelText: 'Keywords'),
                                ),
                                selectedItems: controller.selectedKeyWordsList,
                                popupProps:
                                    PopupPropsMultiSelection.modalBottomSheet(
                                        showSearchBox: true,
                                        isFilterOnline: false,
                                        showSelectedItems: true,
                                        searchFieldProps: TextFieldProps(
                                            decoration: const InputDecoration(
                                                labelText:
                                                    'search for keywords'),
                                            controller:
                                                TextEditingController())),
                                items: controller.keywordsItems,
                                onChanged: (List<String>? data) {
                                  controller.selectedKeyWordsList.value = data!;
                                },
                              ),

                              vSpace,
                            ],
                          ),
                        ),
                      ),
                      vSpace,
                      Container(
                        height: 70,
                        decoration: BoxDecoration(
                            color: AppColor.primaryBlueColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Button(
                                cornerRadius: 12,
                                buttonText: 'Reset',
                                onTap: () {
                                  controller.resetValues();
                                },
                                color: AppColor.greyColor,
                                textColor: AppColor.whiteColor,
                              ),
                            ),
                            Expanded(
                              child: Button(
                                buttonText: 'Submit',
                                cornerRadius: 12,
                                onTap: () {
                                  controller.loadListings(onComplete:
                                      (PropertyListingResponseModel
                                          propertyListingModel) {
                                    Get.offAndToNamed(PropertyListingPage.id,
                                        arguments: propertyListingModel);
                                  });
                                },
                                textColor: AppColor.whiteColor,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  vSpace,
                  if (controller.isLoading.isTrue) LoadingWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
