import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/controllers/google_map_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import '../../../../common/loading_widget.dart';

class GoogleMapPageNearByPlaces extends GetView<MyGoogleMapController> {
  GoogleMapPageNearByPlaces({Key? key}) : super(key: key);
  static const id = '/GoogleMapPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(goBack: true, title: Get.arguments[2]),
      body: GetX<MyGoogleMapController>(
        initState: (state) {
          controller.initialize(
              lat: Get.arguments[0] ?? 31.4713968,
              lng: Get.arguments[1] ?? 74.2705732,
              propertyName: Get.arguments[2] ?? '-');
        },
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: controller.propertyPosition,
                        markers: controller.markers,
                        onMapCreated: controller.onMapCreated,
                      ),
                    ),
                    vSpace,
                    Text("Near by places",
                        style: AppTextStyles.textStyleBoldBodyMedium),
                    vSpace,
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      height: 80.h,
                      child: ListView.builder(
                          itemCount: controller.items.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Obx(() {
                              return InkWell(
                                onTap: () {
                                  controller.selectedItem.value = index;

                                  controller.searchForLocation(
                                      type: controller.items[index]);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color:
                                          controller.selectedItem.value == index
                                              ? AppColor.green
                                              : AppColor.alphaGrey,
                                      border: Border.all(
                                          color:
                                              controller.selectedItem.value ==
                                                      index
                                                  ? AppColor.whiteColor
                                                  : AppColor.blackColor),
                                      borderRadius: BorderRadius.circular(14)),
                                  child: Text(
                                    controller.items[index],
                                    style: AppTextStyles.textStyleBoldBodyMedium
                                        .copyWith(
                                            color:
                                                controller.selectedItem.value ==
                                                        index
                                                    ? AppColor.whiteColor
                                                    : AppColor.blackColor),
                                  ),
                                ),
                              );
                            });
                          }),
                    ),
                    vSpace,
                  ],
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
