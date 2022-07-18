import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zeerac_flutter/common/app_constants.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/controllers/create_auction_controller.dart';
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
import '../../models/cities_model.dart';
import '../../models/country_model.dart';

///basic information widget
class AuctionBasicInformationWidget extends GetView<CreateAuctionController>
    with PropertyListingWidgets {
  AuctionBasicInformationWidget({Key? key}) : super(key: key);

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
                  hintText: 'Price',
                  inputType: TextInputType.number,
                  controller: controller.auctionPriceController),

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

              getTextField(
                  hintText: 'Total files',
                  inputType: TextInputType.number,
                  controller: controller.auctionTotalFilesController),

              vSpace,

              getTextField(
                  hintText: 'Maximum files',
                  inputType: TextInputType.number,
                  validator: (value) {
                    int temp = int.tryParse(value) ?? 0;
                    if (temp >
                        (int.tryParse(
                                controller.auctionTotalFilesController.text) ??
                            0)) {
                      return 'Maximum files cant be greater than total files';
                    }
                    return null;
                  },
                  controller: controller.auctionMaximumFiles),
              vSpace,
              getTextField(
                  hintText: 'Minimum files',
                  inputType: TextInputType.number,
                  validator: (value) {
                    int temp = int.tryParse(value) ?? 0;
                    if (temp >
                        (int.tryParse(controller.auctionMaximumFiles.text) ??
                            0)) {
                      return 'Minimum files cant be greater than Maximum files';
                    }
                    return null;
                  },
                  controller: controller.auctionMinimumFiles),

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

              ///Property Space
              getTextField(
                  hintText: 'Property Space',
                  maxLines: 1,
                  inputType: TextInputType.number,
                  controller: controller.auctionSpaceController),

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

              ///Property Description
              getTextField(
                  hintText: 'Property Description',
                  maxLines: 6,
                  minLines: 4,
                  controller: controller.auctionDescriptionController),

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

///location and address
class AuctionLocationPicker extends GetView<CreateAuctionController>
    with PropertyListingWidgets {
  AuctionLocationPicker({Key? key}) : super(key: key);
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
          return Padding(
            padding: EdgeInsets.only(left: 25.w, right: 25.w),
            child: Form(
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

                  ///country filter

                  FutureBuilder(
                      future: controller.getCountriesList(),
                      builder: (context,
                          AsyncSnapshot<List<CountryModel>> snapShot) {
                        if (snapShot.data != null) {
                          return DropdownSearch<CountryModel>(
                            itemAsString: (item) {
                              return item.name ?? '';
                            },
                            selectedItem: controller.selectedCountry.value,
                            clearButtonProps:
                                const ClearButtonProps(isVisible: true),
                            dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                    labelText: 'Country',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50.r),
                                      borderSide: const BorderSide(
                                          color: AppColor.alphaGrey),
                                    ),
                                    isDense: true)),
                            popupProps: PopupProps.modalBottomSheet(
                                showSearchBox: true,
                                isFilterOnline: true,
                                searchFieldProps: TextFieldProps(
                                    decoration: const InputDecoration(
                                        labelText: 'search for the country'),
                                    controller: TextEditingController())),
                            items: snapShot.data!,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                              return null;
                            },
                            onChanged: (CountryModel? data) {
                              controller.selectedCountry.value = data;
                              controller.selectedPredictionArea.value = null;
                              controller.selectedPredictionCity.value = null;
                            },
                          );
                        }
                        return Container();
                      }),

                  vSpace,

                  ///city filter
                  DropdownSearch<Predictions>(
                    itemAsString: (item) {
                      return item.structuredFormatting?.mainText ?? '';
                    },
                    selectedItem: controller.selectedPredictionCity.value,
                    clearButtonProps: const ClearButtonProps(isVisible: true),
                    validator: (value) {
                      if (value == null) {
                        return 'Required';
                      }
                      return null;
                    },
                    dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                            labelText: 'City',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.r),
                              borderSide:
                                  const BorderSide(color: AppColor.alphaGrey),
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
                        "https://maps.googleapis.com/maps/api/place/autocomplete/json?sensor=false&types=(cities)&key=${ApiConstants.googleApiKey}&components=country:${controller.selectedCountry.value?.code ?? 'Pk'.toLowerCase()}",
                        queryParameters: {"input": filter},
                      );
                      var models = CitySuggestions.fromJson(response.data);

                      return Future.value(models.predictions);
                    },
                    onChanged: (Predictions? data) {
                      controller.selectedPredictionCity.value = data;
                      controller.selectedPredictionArea.value = null;
                    },
                  ),

                  vSpace,

                  ///Area filter
                  DropdownSearch<Predictions>(
                    itemAsString: (item) {
                      return item.structuredFormatting?.mainText ?? '';
                    },
                    selectedItem: controller.selectedPredictionArea.value,
                    clearButtonProps: const ClearButtonProps(isVisible: true),
                    /* validator: (value) {
                                      if (value == null) {
                                        return 'Required';
                                      }
                                      return null;
                                    },*/
                    dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                            labelText: 'Area',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.r),
                              borderSide:
                                  const BorderSide(color: AppColor.alphaGrey),
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
                        "https://maps.googleapis.com/maps/api/place/autocomplete/json?sensor=false&types=(regions)&key=${ApiConstants.googleApiKey}&components=country:${controller.selectedCountry.value?.code ?? 'Pk'.toLowerCase()}",
                        queryParameters: {
                          "input": filter,
                          'location': controller
                                  .selectedPredictionCity.value?.description ??
                              ''
                        },
                      );
                      var models = CitySuggestions.fromJson(response.data);

                      return Future.value(models.predictions);
                    },
                    onChanged: (Predictions? data) {
                      controller.selectedPredictionArea.value = data;
                    },
                  ),

                  vSpace,
                  getTextField(
                      hintText: 'Neighbourhood',
                      leftPadding: 0,
                      rightPadding: 0,
                      inputType: TextInputType.text,
                      controller: controller.auctionNeighborhoodController),

                  vSpace,

                  getTextField(
                      hintText: 'Address',
                      maxLines: 6,
                      minLines: 4,
                      leftPadding: 0,
                      rightPadding: 0,
                      inputType: TextInputType.text,
                      controller: controller.auctionAddressController),

                  vSpace,

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
                  Button(
                      textColor: AppColor.whiteColor,
                      leftPadding: 50.w,
                      rightPading: 50.w,
                      buttonText: 'Proceed',
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          if (controller.picturesList.isNotEmpty) {
                            controller.goForward();
                          } else {
                            AppPopUps.showSnackBar(
                                message: 'Add some images', context: context);
                          }
                        }
                      }),

                  vSpace,
                  vSpace,
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

///property details final
class AuctionPropertyFinalSubmitViewDetails
    extends GetView<CreateAuctionController> with PropertyListingWidgets {
  const AuctionPropertyFinalSubmitViewDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CarouselSlider(
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
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ///price widget
                      Container(
                        decoration:
                            const BoxDecoration(color: AppColor.alphaGrey),
                        padding: const EdgeInsets.all(14),
                        child: Center(
                          child: Text(
                            "${controller.auctionSpaceController.text} ${controller.selectedSpaceUnit.value}",
                            style: AppTextStyles.textStyleBoldTitleLarge,
                          ),
                        ),
                      ),

                      ///description
                      Text(
                        controller.auctionDescriptionController.text,
                        style: AppTextStyles.textStyleNormalLargeTitle,
                      ),

                      ///location

                      Text(
                        controller.auctionAddressController.text,
                        style: AppTextStyles.textStyleNormalBodyMedium,
                      ),

                      Text(
                        controller.selectedPredictionCity.value
                                ?.structuredFormatting?.mainText ??
                            '',
                        style: AppTextStyles.textStyleNormalBodyMedium,
                      ),
                      const Divider(),
                      vSpace,
                      Text(
                        "Details",
                        style: AppTextStyles.textStyleBoldSubTitleLarge,
                      ),
                      vSpace,
                      keyValueRowWidget(
                          title: "Total files",
                          value: controller.auctionTotalFilesController.text,
                          isGrey: true),
                      keyValueRowWidget(
                          title: "Maximum files",
                          value: controller.auctionMaximumFiles.text,
                          isGrey: false),
                      keyValueRowWidget(
                          title: "Minimum files",
                          value: controller.auctionMinimumFiles.text,
                          isGrey: true),
                      keyValueRowWidget(
                          title: "Type",
                          value: controller.selectedSubPropertyType.value,
                          isGrey: false),
                      keyValueRowWidget(
                          title: "Price",
                          value:
                              "${controller.auctionSpaceController.text} ${controller.selectedSpaceUnit.value}",
                          isGrey: true),
                      keyValueRowWidget(
                          title: "Area",
                          value: controller.selectedPredictionArea.value
                                  ?.structuredFormatting?.mainText ??
                              '',
                          isGrey: false),

                      keyValueRowWidget(
                          title: "Purpose",
                          value: controller.selectedPurpose.value,
                          isGrey: true),
                      keyValueRowWidget(
                          title: "Country",
                          value: controller.selectedCountry.value?.name ?? '',
                          isGrey: false),
                      keyValueRowWidget(
                          title: "City",
                          value: controller.selectedPredictionCity.value
                                  ?.structuredFormatting?.mainText ??
                              '',
                          isGrey: true),
                      keyValueRowWidget(
                          title: "Location",
                          value: controller.selectedPredictionArea.value
                                  ?.structuredFormatting?.mainText ??
                              '',
                          isGrey: false),

                      vSpace,
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
                            AppPopUps.showDialogContent(
                                description: 'Auction created successfully',
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
    );
  }
}
