import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/app_constants.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/controllers/property_create_controller.dart';
import 'package:zeerac_flutter/modules/users/pages/google_map_nearby_places_page.dart';
import 'package:zeerac_flutter/modules/users/pages/property_listing/property_listing_widgets.dart';
import 'package:zeerac_flutter/modules/users/pages/sign_up/sign_up_widgets.dart';
import 'package:zeerac_flutter/modules/users/pages/terms_and_conditions/terms_and_conditions_page.dart';
import 'package:zeerac_flutter/utils/app_pop_ups.dart';
import 'package:zeerac_flutter/utils/helpers.dart';

import '../../../../common/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io' show File, Platform;

import '../../../../utils/app_utils.dart';

///basic information widget
class PropertyBasicInformationWidget extends GetView<PropertyCreateController>
    with PropertyListingWidgets {
  PropertyBasicInformationWidget({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return controller.goBackWard();
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              vSpace,
              Text(
                "Basic information",
                style: AppTextStyles.textStyleBoldBodyMedium,
              ),
              vSpace,
              getTextField(
                  hintText: 'Property name',
                  controller: controller.propertyNameController),
              vSpace,

              getTextField(
                  hintText: 'Property Price',
                  inputType: TextInputType.number,
                  controller: controller.propertyPriceController),

              vSpace,

              ///Property Listing Purpose
              MyDropDown(
                suffixIconColor: AppColor.green,
                borderColor: Colors.transparent,
                textColor: AppColor.green,
                labelText: 'Purpose',
                hintText: 'Select',
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
                  controller.propertyTypeMainValue.value = value;
                  controller.changeSelectedPropertyType(value);
                },
              ),

              vSpace,

              ///Property Type sub

              Obx(() {
                return (controller.propertyTypeMainValue.isNotEmpty)
                    ? SizedBox(
                        height: 40,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: AppConstants
                                .propertiesTypeList[
                                    controller.activePropertyTypeList.value]
                                .length,
                            itemBuilder: (context, index) {
                              String value = AppConstants.propertiesTypeList[
                                      controller.activePropertyTypeList.value]
                                  [index];
                              return Obx(() {
                                return Container(
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: controller.selectedSubPropertyType
                                                .value ==
                                            value
                                        ? AppColor.orangeColor
                                        : AppColor.alphaGrey,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      controller.selectedSubPropertyType.value =
                                          value;
                                    },
                                    child: Text(
                                      value,
                                      style: AppTextStyles
                                          .textStyleBoldBodyXSmall
                                          .copyWith(color: AppColor.green),
                                    ),
                                  ),
                                );
                              });
                            }),
                      )
                    : const IgnorePointer();
              }),

              vSpace,

              ///Currency
              MyDropDown(
                suffixIconColor: AppColor.green,
                borderColor: Colors.transparent,
                textColor: AppColor.green,
                labelText: 'Currency',
                hintText: 'Select',
                fillColor: AppColor.alphaGrey,
                items: AppConstants.currenciesType.values.toList(),
                onChange: (value) {
                  controller.selectedCurrencyType.value = value;
                },
              ),

              vSpace,

              ///Property Space Unit
              MyDropDown(
                suffixIconColor: AppColor.green,
                borderColor: Colors.transparent,
                textColor: AppColor.green,
                labelText: 'Property Space Unit',
                hintText: 'Select',
                fillColor: AppColor.alphaGrey,
                items: AppConstants.spaceUnits,
                onChange: (value) {
                  controller.selectedSpaceUnit.value = value;
                },
              ),

              vSpace,

              ///Property Space
              getTextField(
                  hintText: 'Property Space',
                  maxLines: 1,
                  inputType: TextInputType.number,
                  controller: controller.propertySpaceController),

              vSpace,

              ///Property Video Url
              getTextField(
                  hintText: 'Video Url',
                  maxLines: 1,
                  controller: controller.propertyVideoUrlController),

              vSpace,

              ///Property Description
              getTextField(
                  hintText: 'Property Description',
                  maxLines: 6,
                  minLines: 4,
                  controller: controller.propertyDescriptionController),

              vSpace,

              Button(
                  textColor: AppColor.whiteColor,
                  leftPadding: 50.w,
                  rightPading: 50.w,
                  buttonText: 'Proceed',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      controller.goForward();
                    }
                  }),

              vSpace,
            ],
          ),
        ),
      ),
    );
  }
}

///basic detail widget
class PropertyDetailWidget extends GetView<PropertyCreateController>
    with PropertyListingWidgets {
  PropertyDetailWidget({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return controller.goBackWard();
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              vSpace,
              Text(
                "Details",
                style: AppTextStyles.textStyleBoldBodyMedium,
              ),
              vSpace,

              ///beds
              MyDropDown(
                suffixIconColor: AppColor.green,
                borderColor: Colors.transparent,
                textColor: AppColor.green,
                labelText: 'Beds',
                hintText: 'Select',
                fillColor: AppColor.alphaGrey,
                items: AppConstants.beds,
                onChange: (value) {
                  controller.selectedBeds.value = value;
                },
              ),
              vSpace,

              ///Baths
              MyDropDown(
                suffixIconColor: AppColor.green,
                borderColor: Colors.transparent,
                textColor: AppColor.green,
                labelText: 'Baths',
                hintText: 'Select',
                fillColor: AppColor.alphaGrey,
                items: AppConstants.baths,
                onChange: (value) {
                  controller.selectedBaths.value = value;
                },
              ),
              vSpace,

              ///Property Type
              MyDropDown(
                suffixIconColor: AppColor.green,
                borderColor: Colors.transparent,
                textColor: AppColor.green,
                labelText: 'Property Condition',
                hintText: 'Select',
                fillColor: AppColor.alphaGrey,
                items: AppConstants.propertyCondition,
                onChange: (value) {
                  controller.selectedCondition.value = value;
                },
              ),

              vSpace,

              ///Year Built
              getTextField(
                  hintText: 'Property built year',
                  maxLines: 1,
                  inputType: TextInputType.number,
                  controller: controller.propertyBuiltYearController),

              vSpace,

              ///Property Neighborhood
              getTextField(
                  hintText: 'Property Neighborhood',
                  maxLines: 2,
                  controller: controller.propertyNeighborhoodController),

              vSpace,

              Row(
                children: [
                  Flexible(
                    child: Button(
                        textColor: AppColor.whiteColor,
                        leftPadding: 50.w,
                        rightPading: 50.w,
                        buttonText: 'Back',
                        onTap: () {
                          controller.goBackWard();
                        }),
                  ),
                  Flexible(
                    child: Button(
                        textColor: AppColor.whiteColor,
                        leftPadding: 50.w,
                        rightPading: 50.w,
                        buttonText: 'Proceed',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            controller.goForward();
                          }
                        }),
                  ),
                ],
              ),

              vSpace,
            ],
          ),
        ),
      ),
    );
  }
}

///location and address
class PropertyLocationPicker extends GetView<PropertyCreateController>
    with PropertyListingWidgets {
  PropertyLocationPicker({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return controller.goBackWard();
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Obx(() {
          return Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                vSpace,
                Text(
                  "Location and Address",
                  style: AppTextStyles.textStyleBoldBodyMedium,
                ),
                vSpace,
                Button(
                  leftPadding: 50.w,
                  rightPading: 50.w,
                  buttonText: 'Pick Location',
                  textColor: AppColor.whiteColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlacePicker(
                          apiKey: Platform.isAndroid
                              ? ApiConstants.googleApiKey
                              : "YOUR IOS API KEY",
                          onPlacePicked: (result) {
                            controller.setLocationPickedResult(result);
                            printWrapped(result.toString());
                            Navigator.of(context).pop();
                          },
                          zoomControlsEnabled: true,
                          zoomGesturesEnabled: true,
                          searchForInitialValue: true,
                          usePinPointingSearch: true,
                          initialPosition: const LatLng(31.2222, 73.333333),
                          useCurrentLocation: true,
                        ),
                      ),
                    );
                  },
                ),
                vSpace,
                if (controller.pickedLocationResult.value != null)
                  Column(
                    children: [
                      Button(
                        leftPadding: 50.w,
                        rightPading: 50.w,
                        buttonText: 'Reset',
                        textColor: AppColor.whiteColor,
                        onTap: () {
                          controller.setLocationPickedResult(null);
                        },
                      ),
                      vSpace,
                      getTextField(
                          hintText: 'Country',
                          enabled: false,
                          controller:
                              controller.pickedLocationCountryController),
                      vSpace,
                      getTextField(
                          hintText: 'City',
                          enabled: false,
                          controller: controller.pickedLocationCityController),
                      vSpace,
                      getTextField(
                          hintText: 'Area',
                          controller: controller.pickedLocationAreaController),
                      vSpace,
                      getTextField(
                          hintText: 'Formatted address',
                          maxLines: 2,
                          controller: controller
                              .pickedLocationFormattedAddressController),
                      vSpace,
                      getTextField(
                          hintText: 'Address',
                          controller:
                              controller.pickedLocationAddressController),
                      vSpace,
                      getTextField(
                          hintText: 'Block',
                          controller: controller.pickedLocationBlockController),
                      vSpace,
                      getTextField(
                          hintText: 'Latitude',
                          enabled: false,
                          controller: controller.pickedLocationLatController),
                      vSpace,
                      getTextField(
                          hintText: 'Longitude',
                          enabled: false,
                          controller: controller.pickedLocationLngController),
                      vSpace,
                    ],
                  ),
                vSpace,
                Row(
                  children: [
                    Flexible(
                      child: Button(
                          textColor: AppColor.whiteColor,
                          leftPadding: 50.w,
                          rightPading: 50.w,
                          buttonText: 'Back',
                          onTap: () {
                            controller.goBackWard();
                          }),
                    ),
                    Flexible(
                      child: Button(
                          textColor: AppColor.whiteColor,
                          leftPadding: 50.w,
                          rightPading: 50.w,
                          buttonText: 'Proceed',
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              if (controller.pickedLocationResult.value !=
                                  null) {
                                controller.goForward();
                              } else {
                                AppPopUps.showSnackBar(
                                    message: 'Pick location', context: context);
                              }
                            }
                          }),
                    ),
                  ],
                ),
                vSpace,
              ],
            ),
          );
        }),
      ),
    );
  }
}

///features select options
class PropertyFeatures extends GetView<PropertyCreateController>
    with PropertyListingWidgets {
  PropertyFeatures({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return controller.goBackWard();
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Obx(
          () {
            controller.isLoading.value;
            return Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  vSpace,
                  Text(
                    "Select Features",
                    style: AppTextStyles.textStyleBoldBodyMedium,
                  ),
                  vSpace,
                  Wrap(
                      children: AppConstants.propertyFeatures
                          .map(
                            (e) => InkWell(
                              onTap: () {
                                controller.handleFeature(e);
                              },
                              child: getFeatureItem(
                                  title: e,
                                  color:
                                      controller.selectedFeaturesSet.contains(e)
                                          ? AppColor.green
                                          : null),
                            ),
                          )
                          .toList()),
                  vSpace,
                  Text(
                    "Select Thumbnail",
                    style: AppTextStyles.textStyleBoldBodyMedium,
                  ),
                  vSpace,
                  GestureDetector(
                    onTap: () async {
                      AppUtils.showPicker(
                        context: context,
                        onComplete: (File? file) {
                          if (file != null) {
                            controller.thumbnailOfPropertyFile.value = file;
                          }
                        },
                      );
                    },
                    child: SizedBox(
                        height: 250.h,
                        width: double.infinity,
                        child: getImageWidgetPlain(
                            controller.thumbnailOfPropertyFile)),
                  ),
                  vSpace,
                  Text(
                    "Gallery",
                    style: AppTextStyles.textStyleBoldBodyMedium,
                  ),
                  Obx(
                    () => SizedBox(
                      height: 150.h,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "you can upload upto 5 pictures",
                                style: AppTextStyles.textStyleNormalBodyXSmall,
                              ),
                              InkWell(
                                  onTap: () {
                                    if (controller.picturesList.length < 5) {
                                      AppUtils.showPicker(
                                        context: context,
                                        onComplete: (File? file) {
                                          if (file != null) {
                                            controller.picturesList.add(file);
                                          }
                                        },
                                      );
                                    } else {
                                      AppPopUps.showSnackBar(
                                          message:
                                              'Cant upload more than 5 pictres',
                                          context: context);
                                    }
                                  },
                                  child: const Icon(Icons.add)),
                              hSpace,
                            ],
                          ),
                          vSpace,

                          ///local
                          Flexible(
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: controller.picturesList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width: 400.w,
                                  height: 100.h,
                                  decoration: BoxDecoration(
                                      color: AppColor.alphaGrey,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          child: Image.file(
                                            controller.picturesList[index],
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () {
                                            controller.picturesList
                                                .removeAt(index);
                                          },
                                          child: const Icon(
                                            Icons.cancel_outlined,
                                            color: AppColor.redColor,
                                            size: 17,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  vSpace,
                  vSpace,
                  Row(
                    children: [
                      Flexible(
                        child: Button(
                            textColor: AppColor.whiteColor,
                            leftPadding: 50.w,
                            rightPading: 50.w,
                            buttonText: 'Back',
                            onTap: () {
                              controller.goBackWard();
                            }),
                      ),
                      Flexible(
                        child: Button(
                            textColor: AppColor.whiteColor,
                            leftPadding: 50.w,
                            rightPading: 50.w,
                            buttonText: 'Proceed',
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                if (controller.selectedFeaturesSet.isEmpty) {
                                  AppPopUps.showSnackBar(
                                      message: 'Select at least one feature',
                                      context: context);
                                } else if (controller
                                        .thumbnailOfPropertyFile.value ==
                                    null) {
                                  AppPopUps.showSnackBar(
                                      message: 'Select thumbnail',
                                      context: context);
                                } else if (controller.picturesList.isEmpty) {
                                  AppPopUps.showSnackBar(
                                      message: 'Select atleast one picture',
                                      context: context);
                                } else {
                                  controller.goForward();
                                }
                              }
                            }),
                      ),
                    ],
                  ),
                  vSpace,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

///property details final
class PropertyFinalSubmitViewDetails extends GetView<PropertyCreateController>
    with PropertyListingWidgets {
  const PropertyFinalSubmitViewDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: 300.h,
                    backgroundColor: AppColor.blackColor.withOpacity(0.5),
                    floating: true,
                    stretch: true,
                    automaticallyImplyLeading: false,
                    pinned: false,
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${controller.propertyPriceController.text} ${controller.selectedCurrencyType.value}",
                          style: AppTextStyles.textStyleBoldBodyMedium
                              .copyWith(color: AppColor.whiteColor),
                        ),
                        Text(
                          "${controller.propertySpaceController.text} ${controller.selectedSpaceUnit.value}",
                          style: AppTextStyles.textStyleBoldBodySmall
                              .copyWith(color: AppColor.whiteColor),
                        ),
                      ],
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(controller.propertyPriceController.text,
                          style: AppTextStyles.textStyleNormalBodyMedium
                              .copyWith(color: AppColor.whiteColor)),
                      background: CarouselSlider(
                        options: CarouselOptions(height: 300.h, autoPlay: true),
                        items: controller.picturesList.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.all(1),
                                child: Opacity(
                                  opacity: 0.8,
                                  child: Image.file(i, fit: BoxFit.fill),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ];
              },
              body: Column(
                children: [
                  Flexible(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ///price widget
                            Container(
                              decoration: const BoxDecoration(
                                  color: AppColor.alphaGrey),
                              padding: const EdgeInsets.all(14),
                              child: Center(
                                child: Text(
                                  "${controller.propertyPriceController.text} ${controller.selectedSpaceUnit.value}",
                                  style: AppTextStyles.textStyleBoldTitleLarge,
                                ),
                              ),
                            ),

                            ///description
                            Text(
                              controller.propertyDescriptionController.text,
                              style: AppTextStyles.textStyleNormalLargeTitle,
                            ),

                            ///location

                            Text(
                              controller.pickedLocationAddressController.text,
                              style: AppTextStyles.textStyleNormalBodyMedium,
                            ),

                            Text(
                              controller.pickedLocationCityController.text,
                              style: AppTextStyles.textStyleNormalBodyMedium,
                            ),
                            const Divider(),
                            vSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.bed, size: 12),
                                    hSpace,
                                    Text(controller.selectedBeds.value),
                                  ],
                                ),
                                hSpace,
                                Row(
                                  children: [
                                    const Icon(Icons.bathtub, size: 12),
                                    hSpace,
                                    Text(controller.selectedBaths.value),
                                  ],
                                ),
                                hSpace,
                                Row(
                                  children: [
                                    const Icon(Icons.area_chart, size: 12),
                                    hSpace,
                                    Text(
                                        "${controller.propertySpaceController.text} ${controller.selectedSpaceUnit.value}"),
                                  ],
                                ),
                              ],
                            ),
                            vSpace,
                            const Divider(),
                            Text(
                              "Details",
                              style: AppTextStyles.textStyleBoldSubTitleLarge,
                            ),
                            vSpace,
                            keyValueRowWidget(
                                title: "Type",
                                value: controller.selectedSubPropertyType.value,
                                isGrey: false),
                            keyValueRowWidget(
                                title: "Price",
                                value:
                                    "${controller.propertyPriceController.text} ${controller.selectedSpaceUnit.value}",
                                isGrey: true),
                            keyValueRowWidget(
                                title: "Beds",
                                value: controller.selectedBeds.value,
                                isGrey: false),
                            keyValueRowWidget(
                                title: "Baths",
                                value: controller.selectedBaths.value,
                                isGrey: true),
                            keyValueRowWidget(
                                title: "Area",
                                value:
                                    "${controller.propertySpaceController.text} ${controller.selectedSpaceUnit.value}",
                                isGrey: false),
                            keyValueRowWidget(
                                title: "Purpose",
                                value: controller.selectedPurpose.value,
                                isGrey: true),
                            keyValueRowWidget(
                                title: "City",
                                value: controller
                                    .pickedLocationCityController.text,
                                isGrey: false),
                            keyValueRowWidget(
                                title: "Location",
                                value: controller
                                    .pickedLocationAddressController.text,
                                isGrey: true),
                            keyValueRowWidget(
                                title: "Built on",
                                value:
                                    controller.propertyBuiltYearController.text,
                                isGrey: false),
                            keyValueRowWidget(
                                title: "Condition",
                                value: controller.selectedCondition.value,
                                isGrey: true),
                            vSpace,

                            ///features
                            const Divider(),
                            Text(
                              "Features",
                              style: AppTextStyles.textStyleBoldSubTitleLarge,
                            ),
                            vSpace,
                            Wrap(
                              children: controller.selectedFeaturesSet.map((e) {
                                return getFeatureItem(title: e);
                              }).toList(),
                            ),
                            const Divider(),

                            ///location and nearby
                            InkWell(
                              onTap: () {
                                Get.toNamed(GoogleMapPageNearByPlaces.id,
                                    arguments: [
                                      double.tryParse(controller
                                          .pickedLocationLatController.text),
                                      double.tryParse(controller
                                          .pickedLocationLngController.text),
                                      controller.propertyNameController.text
                                    ]);
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.map,
                                    size: 50,
                                  ),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Location & Nearby",
                                          style: AppTextStyles
                                              .textStyleBoldBodyMedium),
                                      Text(
                                          "View property location and nearby amenities",
                                          style: AppTextStyles
                                              .textStyleNormalBodySmall),
                                    ],
                                  )),
                                  const Icon(
                                    Icons.arrow_forward,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),

                            const Divider(),
                            vSpace, vSpace, vSpace, vSpace, vSpace,
                          ],
                        ),
                      ),
                    ),
                  ),

                  ///submit widgets
                  vSpace,

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Obx(() {
                      controller.isTermsAccepted.value;
                      return mySwitch(
                          checkColor: AppColor.green,
                          fillColor: AppColor.alphaGrey,
                          onTickTap: () {
                            controller.isTermsAccepted.value =
                                !controller.isTermsAccepted.value;
                          },
                          onMessageTap: () {
                            Get.toNamed(TermsAndConditionsPage.id);
                          },
                          isActive: controller.isTermsAccepted.value,
                          message: 'Agree to terms and conditions',
                          messageColor: AppColor.primaryBlueColor);
                    }),
                  ),
                  vSpace,

                  Row(
                    children: [
                      Flexible(
                        child: Button(
                            textColor: AppColor.whiteColor,
                            leftPadding: 50.w,
                            rightPading: 50.w,
                            buttonText: 'Back',
                            onTap: () {
                              controller.goBackWard();
                            }),
                      ),
                      Flexible(
                        child: Button(
                            textColor: AppColor.whiteColor,
                            leftPadding: 50.w,
                            rightPading: 50.w,
                            buttonText: 'Submit',
                            onTap: () {
                              if (controller.isTermsAccepted.value) {
                                controller.submit(completion: () {
                                  AppPopUps.showDialog(
                                      description:
                                          'Property created successfully',
                                      dialogType: DialogType.SUCCES,
                                      onOkPress: () {
                                        Get.back();
                                      },
                                      onCancelPress: () {
                                        Get.back();
                                      });
                                });
                              } else {
                                AppPopUps.showSnackBar(
                                    message: 'Accept terms and conditions',
                                    context: context);
                              }
                            }),
                      ),
                    ],
                  ),
                  vSpace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
