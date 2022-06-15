import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/project_detail_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/property_detail_controller.dart';
import 'package:zeerac_flutter/modules/users/models/projects_response_model.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart'
    as propertyModel;
import 'package:zeerac_flutter/modules/users/pages/google_map_page.dart';
import 'package:zeerac_flutter/modules/users/pages/projects_listing/projects_widgets.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import '../../../../common/loading_widget.dart';
import '../../../../common/spaces_boxes.dart';

class ProjectDetailPage extends GetView<ProjectDetailController> {
  ProjectDetailPage({Key? key}) : super(key: key);
  static const id = '/ProjectDetailPage';

  final ProjectModel? project = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(goBack: true, title: project?.propertyType ?? ''),
      body: GetX<ProjectDetailController>(
        initState: (state) {
          if (project != null) {
            controller.initValues(project!);
          }
        },
        builder: (_) {
          printWrapped(
              "${ApiConstants.baseUrl}${controller.projectsResponseModel?.logo}");

          return SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
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
                              url:
                                  "${ApiConstants.baseUrl}${controller.projectsResponseModel?.logo}"),
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
                                  controller.projectsResponseModel?.title ?? '',
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
                                          "${(controller.projectsResponseModel?.minPrice ?? '-')} - ${(controller.projectsResponseModel?.maxPrice ?? '-')} ",
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
                                          "${controller.projectsResponseModel?.city ?? '-'},${controller.projectsResponseModel?.country ?? '-'}",
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
                            Text("Project Details",
                                style: AppTextStyles.textStyleBoldBodyMedium),
                            vSpace,
                            keyValueRowWidget(
                                title: 'Project Id',
                                value:
                                    (controller.projectsResponseModel?.id ?? 0)
                                        .toString(),
                                isGrey: true),
                            keyValueRowWidget(
                                title: 'Property Type',
                                value: (controller.projectsResponseModel
                                            ?.propertyType ??
                                        '-')
                                    .toString(),
                                isGrey: false),
                            keyValueRowWidget(
                                title: 'Locality',
                                value: (controller
                                            .projectsResponseModel?.locality ??
                                        '-')
                                    .toString(),
                                isGrey: true),
                            keyValueRowWidget(
                                title: 'City',
                                value:
                                    (controller.projectsResponseModel?.city ??
                                            '-')
                                        .toString(),
                                isGrey: false),
                            keyValueRowWidget(
                                title: 'Country',
                                value: (controller
                                            .projectsResponseModel?.country ??
                                        '-')
                                    .toString(),
                                isGrey: true),
                            keyValueRowWidget(
                                title: 'Minimum Price',
                                value: (controller
                                            .projectsResponseModel?.minPrice ??
                                        '-')
                                    .toString(),
                                isGrey: false),
                            keyValueRowWidget(
                                title: 'Maximum Price',
                                value: (controller
                                            .projectsResponseModel?.maxPrice ??
                                        '-')
                                    .toString(),
                                isGrey: true),
                          ],
                        ),
                      ),

                      ///location and nearby

                      const Divider(),
                      vSpace,
                      InkWell(
                        onTap: () {
                          Get.toNamed(GoogleMapPage.id, arguments: [
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
                      vSpace,
                      const Divider(),

                      ///Files
                      vSpace,
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller
                                  .projectsResponseModel?.content?.length ??
                              0,
                          itemBuilder: (context, index) {
                            return projectContentWidget(controller
                                .projectsResponseModel!.content![index]);
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
}
