import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/controllers/search_filter_listing_controller.dart';
import 'package:zeerac_flutter/modules/users/models/cities_model.dart';
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
            onTap: () {},
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
              padding: const EdgeInsets.all(18.0),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///filters
                        ///city filter
                        DropdownSearch<Predictions>(
                          itemAsString: (item) {
                            return item.description ?? '';
                          },
                          selectedItem: controller.selectedPredictionCity.value,
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
                              "https://maps.googleapis.com/maps/api/place/autocomplete/json?sensor=false&types=(cities)&key=AIzaSyC0-5OqwY75sPwoncSujsbkJD6wDU7BvOw&components=country:pk",
                              queryParameters: {"input": filter},
                            );
                            var models =
                                CitySuggestions.fromJson(response.data);
                            return Future.value(models.predictions);
                          },
                          onChanged: (Predictions? data) {
                            controller.selectedPredictionCity.value = data!;
                            controller.selectedArea.value = '';
                          },
                        ),
                        vSpace,

                        ///Area filter
                        DropdownSearch<Predictions>(
                          itemAsString: (item) {
                            return item.description ?? '';
                          },
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
                              'https://maps.googleapis.com/maps/api/place/autocomplete/json?sensor=false&types=(regions)&key=AIzaSyC0-5OqwY75sPwoncSujsbkJD6wDU7BvOw&components=country:pk',
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
                            controller.selectedArea.value =
                                data?.description ?? '';
                          },
                        ),
                        vSpace,

                        ///Locations filter
                        DropdownSearch<Predictions>.multiSelection(
                          itemAsString: (item) {
                            return item.description ?? '';
                          },
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration:
                                InputDecoration(labelText: 'Locations'),
                          ),
                          popupProps: PopupPropsMultiSelection.bottomSheet(
                              showSearchBox: true,
                              isFilterOnline: true,
                              searchFieldProps: TextFieldProps(
                                  decoration: const InputDecoration(
                                      labelText: 'search for the locations'),
                                  controller: TextEditingController())),
                          asyncItems: (String filter) async {
                            var response = await Dio().get(
                              'https://maps.googleapis.com/maps/api/place/autocomplete/json?sensor=false&types=address&key=AIzaSyC0-5OqwY75sPwoncSujsbkJD6wDU7BvOw&components=country:pk',
                              queryParameters: {
                                "input":
                                    " ${controller.selectedPredictionCity.value.description},${controller.selectedArea.value},$filter}"
                              },
                            );
                            var models =
                                CitySuggestions.fromJson(response.data);
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Purpose",
                                    style: AppTextStyles.textStyleBoldBodySmall,
                                  ),
                                ),
                                Flexible(
                                  child: MyDropDown(
                                    suffixIconColor: AppColor.green,
                                    borderColor: Colors.transparent,
                                    textColor: AppColor.green,
                                    value: controller.purposes[0],
                                    items: controller.purposes,
                                    onChange: (value) {
                                      controller.selectedPurpose;
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
                            const Divider(),
                            vSpace,
                          ],
                        ),

                        ///Property Type filter
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Property Type",
                                    style: AppTextStyles.textStyleBoldBodySmall,
                                  ),
                                ),
                                Flexible(
                                  child: MyDropDown(
                                    suffixIconColor: AppColor.green,
                                    borderColor: Colors.transparent,
                                    textColor: AppColor.green,
                                    items: controller.propertiesType,
                                    value: controller.propertiesType[0],
                                    onChange: (value) {
                                      controller
                                          .changeSelectedPropertyType(value);
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
                                  itemCount: controller
                                      .propertiesTypeList[controller
                                          .activePropertyTypeList.value]
                                      .length,
                                  itemBuilder: (context, index) {
                                    String value =
                                        controller.propertiesTypeList[controller
                                            .activePropertyTypeList
                                            .value][index];
                                    return Obx(() {
                                      return Container(
                                        margin: const EdgeInsets.all(5),
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: controller.selectedPropertyType
                                                      .value ==
                                                  value
                                              ? AppColor.orangeColor
                                              : AppColor.alphaGrey,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            controller.selectedPropertyType
                                                .value = value;
                                          },
                                          child: Text(
                                            value,
                                            style: AppTextStyles
                                                .textStyleBoldBodyXSmall
                                                .copyWith(
                                                    color: AppColor.green),
                                          ),
                                        ),
                                      );
                                    });
                                  }),
                            ),
                            const Divider(),
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
                                      style:
                                          AppTextStyles.textStyleBoldBodySmall,
                                    ),
                                  ),
                                  Expanded(
                                    child: MyDropDown(
                                      suffixIconColor: AppColor.green,
                                      borderColor: Colors.transparent,
                                      textColor: AppColor.green,
                                      items: controller.beds,
                                      onChange: (value) {
                                        controller.selectedBeds;
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
                              const Divider(),
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
                                      style:
                                          AppTextStyles.textStyleBoldBodySmall,
                                    ),
                                  ),
                                  Expanded(
                                    child: MyDropDown(
                                      suffixIconColor: AppColor.green,
                                      borderColor: Colors.transparent,
                                      textColor: AppColor.green,
                                      items: controller.baths,
                                      onChange: (value) {
                                        controller.selectedBaths;
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
                              const Divider(),
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
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration:
                                InputDecoration(labelText: 'Keywords'),
                          ),
                          popupProps: PopupPropsMultiSelection.bottomSheet(
                              showSearchBox: true,
                              isFilterOnline: true,
                              searchFieldProps: TextFieldProps(
                                  decoration: const InputDecoration(
                                      labelText: 'search for keywords'),
                                  controller: TextEditingController())),
                          items: controller.keywordsItems,
                          onChanged: (List<String?>? data) {
                            printWrapped("*******on changed called*****");
                            controller.selectedKeyWordsList = data;
                          },
                        ),
                      ],
                    ),
                  ),
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
