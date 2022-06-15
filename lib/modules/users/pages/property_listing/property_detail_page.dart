import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/property_detail_controller.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart'
    as propertyModel;
import 'package:zeerac_flutter/modules/users/pages/google_map_page.dart';
import '../../../../common/loading_widget.dart';
import '../../../../common/spaces_boxes.dart';
import 'property_listing_widgets.dart';

class PropertyDetailsPage extends GetView<PropertyDetailController> {
  PropertyDetailsPage({Key? key}) : super(key: key);
  static const id = '/PropertyDetailsPage';

  final propertyModel.PropertyModel? property = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<PropertyDetailController>(
        initState: (state) {
          if (property != null) {
            controller.initValues(property!);
          }
        },
        builder: (_) {
          return SafeArea(
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
                        pinned: false,
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${property?.price ?? ''} ${property?.currency ?? 'PKR'}",
                              style: AppTextStyles.textStyleBoldBodyMedium
                                  .copyWith(color: AppColor.whiteColor),
                            ),
                            Text(
                              "${property?.space ?? ''} ${property?.unit ?? ''}",
                              style: AppTextStyles.textStyleBoldBodySmall
                                  .copyWith(color: AppColor.whiteColor),
                            ),
                          ],
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          title: Text(property?.name ?? '',
                              style: AppTextStyles.textStyleNormalBodyMedium
                                  .copyWith(color: AppColor.whiteColor)),
                          background: CarouselSlider(
                            options:
                                CarouselOptions(height: 300.h, autoPlay: true),
                            items: property?.image.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.all(1),
                                    child: Opacity(
                                      opacity: 0.8,
                                      child: NetworkPlainImage(
                                          fit: BoxFit.contain,
                                          height: 300.h,
                                          url:
                                              "${ApiConstants.baseUrl}${i.image}"),
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
                      Expanded(
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
                                      "${property?.price ?? ''} ${property?.currency ?? 'PKR'}",
                                      style:
                                          AppTextStyles.textStyleBoldTitleLarge,
                                    ),
                                  ),
                                ),

                                ///description
                                Text(
                                  property?.description ?? '',
                                  style:
                                      AppTextStyles.textStyleNormalLargeTitle,
                                ),

                                ///location

                                Text(
                                  property?.address ?? 'dummy location',
                                  style:
                                      AppTextStyles.textStyleNormalBodyMedium,
                                ),

                                Text(
                                  property?.city ?? 'cityyy',
                                  style:
                                      AppTextStyles.textStyleNormalBodyMedium,
                                ),
                                const Divider(),
                                vSpace,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.bed, size: 12),
                                        hSpace,
                                        Text("${property?.beds ?? 0}"),
                                      ],
                                    ),
                                    hSpace,
                                    Row(
                                      children: [
                                        const Icon(Icons.bathtub, size: 12),
                                        hSpace,
                                        Text("${property?.bathrooms ?? 0}"),
                                      ],
                                    ),
                                    hSpace,
                                    Row(
                                      children: [
                                        const Icon(Icons.area_chart, size: 12),
                                        hSpace,
                                        Text(
                                            "${property?.space ?? '0'} ${property?.unit ?? ''}"),
                                      ],
                                    ),
                                  ],
                                ),
                                vSpace,
                                const Divider(),
                                Text(
                                  "Details",
                                  style:
                                      AppTextStyles.textStyleBoldSubTitleLarge,
                                ),
                                vSpace,
                                keyValueRowWidget(
                                    title: "Property Id",
                                    value: property?.propertyId ?? '-',
                                    isGrey: true),
                                keyValueRowWidget(
                                    title: "Type",
                                    value: property?.type ?? '-',
                                    isGrey: false),
                                keyValueRowWidget(
                                    title: "Price",
                                    value:
                                        "${property?.price ?? '-'} ${property?.currency ?? '-'}",
                                    isGrey: true),
                                keyValueRowWidget(
                                    title: "Beds",
                                    value: (property?.beds ?? 0).toString(),
                                    isGrey: false),
                                keyValueRowWidget(
                                    title: "Baths",
                                    value: "${property?.bathrooms ?? 0}",
                                    isGrey: true),
                                keyValueRowWidget(
                                    title: "Area",
                                    value:
                                        "${property?.space ?? '-'} ${property?.unit ?? '-'}",
                                    isGrey: false),
                                keyValueRowWidget(
                                    title: "Purpose",
                                    value: property?.purpose ?? '-',
                                    isGrey: true),
                                keyValueRowWidget(
                                    title: "City",
                                    value: property?.city ?? '-',
                                    isGrey: false),
                                keyValueRowWidget(
                                    title: "Location",
                                    value: property?.loca ?? '-',
                                    isGrey: true),
                                keyValueRowWidget(
                                    title: "Built on",
                                    value: (property?.year ?? 0).toString(),
                                    isGrey: false),
                                keyValueRowWidget(
                                    title: "Condition",
                                    value: property?.condition ?? '-',
                                    isGrey: true),
                                vSpace,

                                ///features
                                const Divider(),
                                Text(
                                  "Features",
                                  style:
                                      AppTextStyles.textStyleBoldSubTitleLarge,
                                ),
                                vSpace,
                                Wrap(
                                  children: controller.featuresList.map((e) {
                                    return getFeatureItem(title: e);
                                  }).toList(),
                                ),
                                const Divider(),

                                ///location and nearby
                                InkWell(
                                  onTap: () {
                                    Get.toNamed(GoogleMapPage.id, arguments: [
                                      property?.lat,
                                      property?.lng,
                                      property?.name
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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

                      ///contact widgets
                      Container(
                        color: AppColor.alphaGrey,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            hSpace,
                            Flexible(
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColor.primaryBlueColor)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.email_outlined),
                                      hSpace,
                                      Flexible(
                                        child: Text(
                                          "Email",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextStyles
                                              .textStyleBoldBodySmall,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            hSpace,
                            Flexible(
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColor.primaryBlueColor)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.call),
                                      hSpace,
                                      Flexible(
                                          child: Text(
                                        "Call",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles
                                            .textStyleBoldBodySmall,
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            hSpace,
                            Flexible(
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColor.primaryBlueColor)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.message),
                                      hSpace,
                                      Flexible(
                                          child: Text(
                                        "Message",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles
                                            .textStyleBoldBodySmall,
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            hSpace,
                          ],
                        ),
                      ),
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
