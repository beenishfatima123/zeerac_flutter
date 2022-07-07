import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/controllers/auction_bid_detail_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/project_detail_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/property_detail_controller.dart';
import 'package:zeerac_flutter/modules/users/models/acutions_listing_response_model.dart';
import 'package:zeerac_flutter/modules/users/models/projects_response_model.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart'
    as propertyModel;
import 'package:zeerac_flutter/modules/users/pages/auctions/auctions_widgets.dart';
import 'package:zeerac_flutter/modules/users/pages/google_map_nearby_places_page.dart';
import 'package:zeerac_flutter/modules/users/pages/projects_listing/projects_widgets.dart';
import 'package:zeerac_flutter/utils/app_alert_bottom_sheet.dart';
import 'package:zeerac_flutter/utils/app_pop_ups.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import '../../../../common/loading_widget.dart';
import '../../../../common/spaces_boxes.dart';

class AuctionBidDetailPage extends GetView<AuctionBidDetailController>
    with AuctionWidgetMixin {
  AuctionBidDetailPage({Key? key}) : super(key: key);
  static const id = '/AuctionBidDetailPage';

  final AuctionFileModel? auctionModel = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(goBack: true, title: auctionModel?.type ?? '-'),
      body: GetX<AuctionBidDetailController>(
        initState: (state) {
          if (auctionModel != null) {
            controller.initValues(auctionModel!);
            controller.loadBiddingOfAuction(
                showAlert: true, propertyFileId: auctionModel!.id.toString());
          }
        },
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                NotificationListener(
                  onNotification: controller.onScrollNotification,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///images and title info
                        Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            NetworkPlainImage(
                                height: 300.h,
                                fit: BoxFit.fill,
                                url: controller.auctionFileModel!.photos.isEmpty
                                    ? ApiConstants.imageNetworkPlaceHolder
                                    : "${ApiConstants.baseUrl}${controller.auctionFileModel?.photos.first}"),
                            Container(
                              width: double.infinity,
                              color: AppColor.blackColor.withOpacity(0.5),
                              padding: EdgeInsets.all(10.h),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.auctionFileModel?.description ??
                                        '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.textStyleBoldTitleLarge
                                        .copyWith(color: AppColor.whiteColor),
                                  ),
                                  Flexible(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Files range:${(controller.auctionFileModel?.minFiles ?? '-')} - ${(controller.auctionFileModel?.maxFiles ?? '-')} ",
                                            style: AppTextStyles
                                                .textStyleNormalBodySmall
                                                .copyWith(
                                                    color: AppColor.whiteColor),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${controller.auctionFileModel?.city ?? '-'},${controller.auctionFileModel?.country ?? '-'}",
                                            style: AppTextStyles
                                                .textStyleNormalBodySmall
                                                .copyWith(
                                                    color: AppColor.whiteColor),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),

                        ///project information
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              vSpace,
                              Button(
                                buttonText: "Place your bid",
                                textColor: AppColor.whiteColor,
                                onTap: () {
                                  showPlacingBidBottomSheet(context);
                                },
                              ),
                              vSpace,
                              vSpace,
                              Text("Property Details",
                                  style: AppTextStyles.textStyleBoldBodyMedium),
                              vSpace,
                              keyValueRowWidget(
                                  title: 'Property Id',
                                  value: (controller.auctionFileModel?.id ?? 0)
                                      .toString(),
                                  isGrey: true),
                              keyValueRowWidget(
                                  title: 'Property Type',
                                  value:
                                      (controller.auctionFileModel?.type ?? '-')
                                          .toString(),
                                  isGrey: false),
                              keyValueRowWidget(
                                  title: 'City',
                                  value:
                                      (controller.auctionFileModel?.city ?? '-')
                                          .toString(),
                                  isGrey: true),
                              keyValueRowWidget(
                                  title: 'Country',
                                  value:
                                      (controller.auctionFileModel?.country ??
                                              '-')
                                          .toString(),
                                  isGrey: false),
                              keyValueRowWidget(
                                  title: 'Price',
                                  value:
                                      "${(controller.auctionFileModel?.price ?? '-').toString()} ${(controller.auctionFileModel?.currency ?? '-').toString()}",
                                  isGrey: true),
                              keyValueRowWidget(
                                  title: 'Space',
                                  value:
                                      "${(controller.auctionFileModel?.space ?? '-').toString()} ${(controller.auctionFileModel?.unit ?? '-').toString()}",
                                  isGrey: false),
                              keyValueRowWidget(
                                  title: 'Neighborhood',
                                  value: (controller
                                              .auctionFileModel?.neighborhood ??
                                          '-')
                                      .toString(),
                                  isGrey: true),
                              keyValueRowWidget(
                                  title: 'Area',
                                  value:
                                      (controller.auctionFileModel?.area ?? '-')
                                          .toString(),
                                  isGrey: false),
                            ],
                          ),
                        ),
                        vSpace,

                        ///location and nearby
                        /*  const Divider(),
                        vSpace,*/
                        /*  InkWell(
                          onTap: () {
                            Get.toNamed(GoogleMapPageNearByPlaces.id, arguments: [
                              controller.projectsResponseModel?.lat,
                              controller.projectsResponseModel?.lng,
                              controller.projectsResponseModel?.title
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Location & Nearby",
                                      style:
                                          AppTextStyles.textStyleBoldBodyMedium),
                                  Text(
                                      "View property location and nearby amenities",
                                      style:
                                          AppTextStyles.textStyleNormalBodySmall),
                                ],
                              )),
                              const Icon(
                                Icons.arrow_forward,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                        vSpace,*/
                        const Divider(),

                        ///Biding
                        vSpace,
                        Text('Biddings',
                            style: AppTextStyles.textStyleBoldTitleLarge),
                        vSpace,
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.biddingList.length,
                            itemBuilder: (context, index) {
                              return biddingWidget(
                                  controller.biddingList[index]!);
                            }),
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
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  getDetailsWidget(
      {required String title, required String value, required bool isGrey}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: isGrey ? AppColor.alphaGrey : AppColor.whiteColor),
      child: Row(
        children: [
          Expanded(
              child: Center(
            child: Text(
              title,
              style: AppTextStyles.textStyleNormalBodyMedium,
            ),
          )),
          Expanded(
              child: Center(
            child: Text(
              value,
              style: AppTextStyles.textStyleNormalBodyMedium,
            ),
          )),
        ],
      ),
    );
  }

  Widget getFeatureItem({required String title}) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: AppColor.alphaGrey, borderRadius: BorderRadius.circular(10)),
      child: Text(
        title,
        style: AppTextStyles.textStyleNormalBodyMedium,
      ),
    );
  }

  void showPlacingBidBottomSheet(BuildContext context) {
    controller.bidPriceTextController.clear();
    controller.bidFilesCountTextController.clear();
    final formKey = GlobalKey<FormState>();
    AppBottomSheets.showAppAlertBottomSheet(
        context: context,
        title: 'Place your bid',
        isDismissable: true,
        isFull: true,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              vSpace,
              MyTextField(
                controller: controller.bidPriceTextController,
                hintText: 'Enter price',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (((value ?? '').isEmpty)) {
                    return 'Required';
                  }
                  return null;
                },
              ),
              vSpace,
              MyTextField(
                  controller: controller.bidFilesCountTextController,
                  hintText: 'Enter files count',
                  validator: (value) {
                    if (((value ?? '').isEmpty) ||
                        int.parse(controller.bidFilesCountTextController.text) <
                            1) {
                      return 'Required';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number),
              vSpace,
              Button(
                buttonText: 'Place Bid',
                onTap: () {
                  if (formKey.currentState?.validate() ?? false) {
                    Get.back();
                    controller.placeYourBid();
                  }
                },
              ),
            ],
          ),
        ));
  }
}
