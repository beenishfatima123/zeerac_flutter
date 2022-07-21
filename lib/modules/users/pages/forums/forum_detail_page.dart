import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/controllers/forum_detail_controller.dart';
import 'package:zeerac_flutter/modules/users/models/forums_response_model.dart';
import 'package:zeerac_flutter/modules/users/pages/forums/forums_widgets.dart';
import 'package:zeerac_flutter/utils/app_pop_ups.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import '../../../../common/loading_widget.dart';

class ForumDetailPage extends GetView<ForumDetailController>
    with ForumWidgetsMixin {
  ForumDetailPage({Key? key}) : super(key: key);
  static const id = '/ForumDetailPage';

  ForumModel? forumModel = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(goBack: true, title: 'Thread'),
      body: GetX<ForumDetailController>(
        initState: (state) {
          if (forumModel != null) {
            controller.initController(forumModel: forumModel!);
          }
        },
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                if (forumModel != null)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 50.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    NetworkCircularImage(
                                        url: controller.forumModel.groupPhoto ??
                                            ApiConstants
                                                .imageNetworkPlaceHolder,
                                        radius: 200.r),
                                    hSpace,
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              controller.forumModel.title ??
                                                  '-',
                                              style: AppTextStyles
                                                  .textStyleNormalLargeTitle),
                                          vSpace,
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.favorite_border,
                                                    size: 100.r,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                        "${controller.forumModel.likesCount ?? 0}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: AppTextStyles
                                                            .textStyleBoldBodyXSmall),
                                                  )
                                                ],
                                              )),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .person_pin_circle_outlined,
                                                      size: 100.r,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                          "${controller.forumModel.repliesCount ?? 0}",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: AppTextStyles
                                                              .textStyleBoldBodyXSmall),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                vSpace,
                                Flexible(
                                    child: Text(
                                        controller.forumModel.content ?? '-',
                                        style: AppTextStyles
                                            .textStyleNormalBodyMedium)),
                              ],
                            ),
                          ),
                        ),
                        vSpace,
                        Text(
                            "Replies (${controller.forumModel.replies?.length ?? 0})",
                            style: AppTextStyles.textStyleBoldSubTitleLarge),
                        vSpace,
                        Expanded(
                          child: ListView.builder(
                            itemCount:
                                controller.forumModel.replies?.length ?? 0,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return forumReplyContainer(
                                  replyModel:
                                      controller.forumModel.replies![index]);
                            },
                          ),
                        ),
                        vSpace,
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(
                                child: MyTextField(
                                  controller:
                                      controller.sendReplyTextController,
                                  leftPadding: 0,
                                  rightPadding: 0,
                                  focusBorderColor: AppColor.primaryBlueColor,
                                  unfocusBorderColor: AppColor.primaryBlueColor,
                                  hintText: 'Add your reply...',
                                  maxLines: 4,
                                ),
                              ),
                              hSpace,
                              InkWell(
                                onTap: () {
                                  if (controller.sendReplyTextController.text
                                      .isNotEmpty) {
                                    controller.sendReplyToThread(
                                      onComplete: () {
                                        controller.sendReplyTextController
                                            .clear();
                                        AppPopUps.showDialogContent(
                                            title: 'Success',
                                            description: 'Reply Posted',
                                            dialogType: DialogType.SUCCES);
                                      },
                                    );
                                  }
                                },
                                child: const Icon(
                                  Icons.send,
                                  color: AppColor.primaryBlueColor,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        )
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
