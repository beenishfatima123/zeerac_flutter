import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/trends_controller.dart';
import 'package:zeerac_flutter/modules/users/models/country_model.dart';
import 'package:zeerac_flutter/modules/users/pages/trends/trends_details_page.dart';
import '../../../../common/loading_widget.dart';
import '../../../../common/spaces_boxes.dart';
import '../../../../dio_networking/app_apis.dart';
import '../../models/cities_model.dart';

class TrendsPage extends GetView<TrendsController> {
  TrendsPage({Key? key}) : super(key: key);
  static const id = '/TrendsPage';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<TrendsController>(
        initState: (state) {},
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      vSpace,
                      Text(
                        'Search For Trends',
                        style: AppTextStyles.textStyleBoldTitleLarge,
                      ),
                      vSpace,
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 50.w),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColor.alphaGrey,
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 20.h, horizontal: 100.w),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                vSpace,

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
                                          selectedItem:
                                              controller.selectedCountry.value,
                                          clearButtonProps:
                                              const ClearButtonProps(
                                                  isVisible: true),
                                          dropdownDecoratorProps:
                                              DropDownDecoratorProps(
                                                  dropdownSearchDecoration:
                                                      InputDecoration(
                                                          labelText: 'Country',
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50.r),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: AppColor
                                                                        .alphaGrey),
                                                          ),
                                                          isDense: true)),
                                          popupProps: PopupProps.modalBottomSheet(
                                              showSearchBox: true,
                                              isFilterOnline: true,
                                              searchFieldProps: TextFieldProps(
                                                  decoration: const InputDecoration(
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
                                            controller.selectedCountry.value =
                                                data;
                                            controller.selectedPredictionArea
                                                .value = null;
                                            controller.selectedPredictionCity
                                                .value = null;
                                          },
                                        );
                                      }
                                      return Container();
                                    }),

                                vSpace,

                                ///city filter
                                DropdownSearch<Predictions>(
                                  itemAsString: (item) {
                                    return item
                                            .structuredFormatting?.mainText ??
                                        '';
                                  },
                                  selectedItem:
                                      controller.selectedPredictionCity.value,
                                  clearButtonProps:
                                      const ClearButtonProps(isVisible: true),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                                  labelText: 'City',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.r),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: AppColor
                                                                .alphaGrey),
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
                                    var models =
                                        CitySuggestions.fromJson(response.data);

                                    return Future.value(models.predictions);
                                  },
                                  onChanged: (Predictions? data) {
                                    controller.selectedPredictionCity.value =
                                        data;
                                    controller.selectedPredictionArea.value =
                                        null;
                                  },
                                ),

                                vSpace,

                                ///Area filter
                                DropdownSearch<Predictions>(
                                  itemAsString: (item) {
                                    return item
                                            .structuredFormatting?.mainText ??
                                        '';
                                  },
                                  selectedItem:
                                      controller.selectedPredictionArea.value,
                                  clearButtonProps:
                                      const ClearButtonProps(isVisible: true),
                                  /* validator: (value) {
                                    if (value == null) {
                                      return 'Required';
                                    }
                                    return null;
                                  },*/
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                                  labelText: 'Area',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.r),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: AppColor
                                                                .alphaGrey),
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
                                                .selectedPredictionCity
                                                .value
                                                ?.description ??
                                            ''
                                      },
                                    );
                                    var models =
                                        CitySuggestions.fromJson(response.data);

                                    return Future.value(models.predictions);
                                  },
                                  onChanged: (Predictions? data) {
                                    controller.selectedPredictionArea.value =
                                        data;
                                  },
                                ),

                                vSpace,

                                Button(
                                  buttonText: 'Search',
                                  textColor: AppColor.whiteColor,
                                  onTap: () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      controller.searchForTrends(
                                        onComplete: () {
                                          Get.to(
                                              () => const TrendsDetailPage());
                                        },
                                      );
                                    }
                                  },
                                ),

                                vSpace,
                              ],
                            ),
                          ),
                        ),
                      ),
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
