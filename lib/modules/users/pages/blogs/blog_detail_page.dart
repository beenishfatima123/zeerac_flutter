import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/controllers/blog_detail_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import 'package:zeerac_flutter/modules/users/models/blog_response_model.dart';
import 'package:zeerac_flutter/modules/users/pages/blogs/blog_widgets.dart';
import 'package:zeerac_flutter/utils/app_utils.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import '../../../../common/loading_widget.dart';
import '../../../../common/styles.dart';

class BlogDetailPage extends GetView<BlogDetailController> with BlogsWidgets {
  BlogDetailPage({Key? key}) : super(key: key);
  static const id = '/BlogDetailPage';
  BlogModel? blogModel = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<BlogDetailController>(
        initState: (state) {
          controller.blogModel = blogModel;
        },
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                (blogModel == null)
                    ? Text('No Detail Found',
                        style: AppTextStyles.textStyleBoldBodyMedium)
                    : NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverAppBar(
                              expandedHeight: 300.h,
                              backgroundColor:
                                  AppColor.blackColor.withOpacity(0.5),
                              floating: false,
                              snap: false,
                              pinned: false,
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (controller.blogModel?.authorName ?? ''),
                                    style: AppTextStyles.textStyleBoldBodyMedium
                                        .copyWith(color: AppColor.whiteColor),
                                  ),
                                  Text(
                                    formatDateTime(DateTime.tryParse(
                                            controller.blogModel?.createdAt ??
                                                '-'))
                                        .toString(),
                                    style: AppTextStyles.textStyleBoldBodySmall
                                        .copyWith(color: AppColor.whiteColor),
                                  ),
                                ],
                              ),
                              flexibleSpace: FlexibleSpaceBar(
                                title: Text(
                                    controller.blogModel?.authorName ?? '',
                                    style: AppTextStyles
                                        .textStyleNormalBodyMedium
                                        .copyWith(color: AppColor.whiteColor)),
                                background: Opacity(
                                  opacity: 0.7,
                                  child: NetworkPlainImage(
                                    height: 350.h,
                                    url:
                                        "${ApiConstants.baseUrl}${controller.blogModel?.blogPhoto ?? ''}",
                                  ),
                                ),
                                collapseMode: CollapseMode.pin,
                              ),
                            ),
                          ];
                        },
                        body: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildChipsList(blogModel?.tags?.split(",") ?? []),
                            vSpace,
                            vSpace,
                            Text(blogModel?.authorName ?? '-',
                                style: AppTextStyles.textStyleBoldBodyMedium),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                      formatDateTime(DateTime.tryParse(
                                              blogModel?.createdAt ?? '-'))
                                          .toString(),
                                      style: AppTextStyles
                                          .textStyleNormalBodyXSmall),
                                ),
                                NetworkCircularImage(
                                    width: 60,
                                    height: 60,
                                    url:
                                        "${ApiConstants.baseUrl}${blogModel?.authorPhoto ?? ''}"),
                                hSpace,
                              ],
                            ),
                            vSpace,
                            vSpace,
                            vSpace,
                            Text("Description",
                                style: AppTextStyles.textStyleBoldBodyMedium),
                            Text(blogModel?.description ?? '',
                                style: AppTextStyles.textStyleNormalBodyMedium),
                            vSpace,
                            Text("Content",
                                style: AppTextStyles.textStyleBoldBodyMedium),
                            Expanded(
                              child: Text(blogModel?.content ?? '-',
                                  style:
                                      AppTextStyles.textStyleNormalBodyMedium),
                            ),
                            vSpace,
                            Text("Reference",
                                style: AppTextStyles.textStyleBoldBodyMedium),
                            InkWell(
                              onTap: () {
                                AppUtils.launchUriUrl(
                                    blogModel?.references ?? 'google.com');
                              },
                              child: Text(blogModel?.references ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.textStyleBoldBodyMedium
                                      .copyWith(
                                          color: AppColor.primaryBlueColor,
                                          decoration:
                                              TextDecoration.underline)),
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
