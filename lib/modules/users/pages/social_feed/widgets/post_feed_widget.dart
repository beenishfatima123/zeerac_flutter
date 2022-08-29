import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/controllers/social_feed_controller.dart';
import 'package:zeerac_flutter/modules/users/pages/social_feed/social_feed_widget_mixin.dart';
import 'package:zeerac_flutter/utils/helpers.dart';

import '../../../../../common/styles.dart';
import '../../../../../utils/user_defaults.dart';
import '../../../models/social_posts_response_model.dart';

class PostFeedWidget extends GetView<SocialFeedController>
    with SocialFeedWidgetMixin {
  PostFeedWidget({required this.postModel, required this.onViewMoreTap});

  late Rx<SocialPostModel> postModel;
  int alreadyPresentCommentId = -1;
  Function() onViewMoreTap;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SocialFeedController>(
      id: 'feed',
      builder: (logic) {
        RxInt isLikedValue = checkIsLiked(postModel: postModel);
        int commentsLength = (postModel.value.comments.length);

        return Card(
          color: AppColor.alphaGrey,
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    NetworkCircularImage(
                        url:
                            "${ApiConstants.baseUrl}${postModel.value.userFk?.photo ?? ''}",
                        radius: 18),
                    hSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            postModel.value.userFk?.username ?? '-',
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.textStyleBoldBodyMedium
                                .copyWith(letterSpacing: 1),
                          ),
                          hSpace,
                          Text(
                            formatDateTime(
                                DateTime.tryParse(postModel.value.createdAt!),
                                format: 'dd-MM-yyyy hh:ss a'),
                            style: AppTextStyles.textStyleNormalBodySmall
                                .copyWith(color: AppColor.greyColor),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.more_vert,
                        size: 30,
                        color: AppColor.greyColor,
                      ),
                      onPressed: onViewMoreTap,
                    )
                  ],
                ),
                vSpace,
                Text(
                  postModel.value.description ?? '-',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.textStyleNormalBodyMedium.copyWith(),
                ),
                vSpace,
                postModel.value.propertyPostImage != ''
                    ? NetworkPlainImage(
                        url:
                            "${ApiConstants.baseUrl}${postModel.value.propertyPostImage ?? ''}",
                        height: 400.h,
                      )
                    : const IgnorePointer(),
                vSpace,

                ///likes count and comments counts here....
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white)),
                                child: const Center(
                                  child: Icon(Icons.thumb_up,
                                      size: 12, color: Colors.white),
                                ),
                              ),
                              hSpace,
                              Text(
                                postModel.value.likes
                                    .where((element) =>
                                        ((element.like ?? false) == true))
                                    .toList()
                                    .length
                                    .toString(),
                                style: AppTextStyles.textStyleNormalBodyMedium
                                    .copyWith(color: AppColor.greyColor),
                              )
                            ],
                          ),
                          hSpace,
                          Row(
                            children: [
                              Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white)),
                                child: const Center(
                                  child: Icon(Icons.thumb_down,
                                      size: 12, color: Colors.white),
                                ),
                              ),
                              hSpace,
                              Text(
                                postModel.value.likes
                                    .where((element) =>
                                        ((element.dislike ?? false) == true))
                                    .toList()
                                    .length
                                    .toString(),
                                style: AppTextStyles.textStyleNormalBodyMedium
                                    .copyWith(color: AppColor.greyColor),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "${postModel.value.comments.length.toString()} Comments",
                      style: AppTextStyles.textStyleNormalBodyMedium
                          .copyWith(color: AppColor.greyColor),
                    )
                  ],
                ),
                vSpace,

                ///like comment share
                SizedBox(
                  height: 50.h,
                  child: ListView(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.greyColor),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            switch (isLikedValue.value) {
                              case 0: //nutral
                                isLikedValue.value = 1;
                                //send network request here////

                                controller.addNewLike(
                                    postModel: postModel.value,
                                    alreadyPresentCommentId:
                                        alreadyPresentCommentId,
                                    completion: (LikesModel likeModel) {
                                      _updateValue(likeModel);
                                    },
                                    isLiked: true,
                                    isDisliked: false);
                                break;
                              case 1: //liked
                                isLikedValue.value = 2;

                                controller.addNewLike(
                                    postModel: postModel.value,
                                    alreadyPresentCommentId:
                                        alreadyPresentCommentId,
                                    completion: (LikesModel likeModel) {
                                      _updateValue(likeModel);
                                    },
                                    isLiked: false,
                                    isDisliked: true);
                                break;
                              case 2: //disliked

                                isLikedValue.value = 0;

                                controller.addNewLike(
                                    alreadyPresentCommentId:
                                        alreadyPresentCommentId,
                                    postModel: postModel.value,
                                    completion: (LikesModel likeModel) {
                                      _updateValue(likeModel);
                                    },
                                    isLiked: false,
                                    isDisliked: false);
                                break;
                            }
                          },
                          child: Obx(() {
                            return Center(
                              child: getIconOnLiked(isLikedValue.value),
                            );
                          }),
                        ),
                      ),
                      hSpace,
                      InkWell(
                        onTap: () {
                          showBottomSheetForComments(postModel: postModel);
                        },
                        child: makeActionButton(
                            title: 'Comments', iconData: Icons.message),
                      ),
                      hSpace,
                      makeActionButton(title: 'Share', iconData: Icons.share),
                    ],
                  ),
                ),
                vSpace,
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///show if comments size is more than 5
                    if (commentsLength > 4)
                      GestureDetector(
                        onTap: () {
                          showBottomSheetForComments(postModel: postModel);
                        },
                        child: Text('Load Previous Comments',
                            style: AppTextStyles.textStyleBoldBodySmall
                                .copyWith(color: AppColor.greyColor)),
                      ),
                    vSpace,
                    ListView.builder(
                        itemCount: commentsLength > 4 ? 4 : commentsLength,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return commentCommenterView(
                              comment:
                                  postModel.value.comments.elementAt(index));
                        }),
                    vSpace,
                    GestureDetector(
                      onTap: () {
                        showBottomSheetForComments(postModel: postModel);
                      },
                      child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: AppColor.whiteColor,
                              border: Border.all(color: AppColor.greyColor),
                              borderRadius: BorderRadius.circular(8)),
                          child: Text('Enter you comment',
                              style: AppTextStyles.textStyleNormalBodyMedium)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget makeActionButton({required String title, required IconData iconData}) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.greyColor),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(iconData, color: Colors.grey, size: 18),
              hSpace,
              Text(
                title,
                style: AppTextStyles.textStyleNormalBodySmall
                    .copyWith(color: AppColor.greyColor),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///0 nutral 1 liked 2 diskliked
  RxInt checkIsLiked({required Rx<SocialPostModel> postModel}) {
    RxInt result = 0.obs;
    LikesModel? like = postModel.value.likes.firstWhereOrNull((element) =>
        ((element.userFk ?? -1).toString() ==
            (UserDefaults.getCurrentUserId() ?? '')));

    if (like != null) {
      ///required to make put request
      alreadyPresentCommentId = like.id ?? -1;

      if ((like.like ?? false) &&
          ((like.dislike ?? false) == false) &&
          (like.commentFk.toString() != UserDefaults.getCurrentUserId())) {
        result.value = 1;
      } else if ((like.dislike ?? false)) {
        result.value = 2;
      }
    }

    return result;
  }

  void _updateValue(LikesModel likeModel) {
    if (alreadyPresentCommentId != -1) {
      int index = postModel.value.likes
          .indexWhere((element) => element.id == likeModel.id);
      postModel.value.likes[index] = likeModel;
    } else {
      postModel.value.likes.add(likeModel);
    }
    controller.update(['feed']);
  }
}
