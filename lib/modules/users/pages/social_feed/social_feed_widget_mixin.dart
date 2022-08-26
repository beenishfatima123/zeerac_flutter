import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/models/group_member_requests_response_model.dart';
import 'package:zeerac_flutter/modules/users/models/social_group_response_model.dart';
import 'package:zeerac_flutter/modules/users/models/social_posts_response_model.dart';
import 'package:zeerac_flutter/modules/users/pages/social_feed/all_comments_view.dart';
import 'package:zeerac_flutter/utils/app_alert_bottom_sheet.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import 'package:zeerac_flutter/utils/user_defaults.dart';

import '../../../../my_application.dart';
import '../../../../utils/app_utils.dart';
import '../../controllers/social_feed_controller.dart';

mixin SocialFeedWidgetMixin {
  /////Groups items
  Widget getGroupView(
      {required onViewGroupTap,
      required onSettingsTap,
      SocialGroupModel? groupModel,
      required onRequestGroupTap,
      required bool isOwns}) {
    bool isUserMember = (((groupModel?.members
            ?.contains(int.tryParse(UserDefaults.getCurrentUserId() ?? '0'))) ??
        false));

    return Card(
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NetworkPlainImage(
              url: "${ApiConstants.baseUrl}${groupModel?.groupPhoto}",
              height: 200.h,
            ),
            vSpace,
            Row(
              children: [
                Expanded(
                  child: Text(
                    groupModel?.groupName ?? '-',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.textStyleBoldBodyMedium,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 18),
                    Text(
                      groupModel?.membersCount?.toString() ?? '-',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.textStyleBoldBodyMedium,
                    ),
                  ],
                ),
                hSpace,
              ],
            ),
            Text(
              groupModel?.description ?? '-',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.textStyleNormalBodySmall,
            ),
            vSpace,
            isUserMember
                ? Button(
                    buttonText: 'View Group',
                    onTap: onViewGroupTap,
                  )
                : Button(
                    buttonText: 'Request join',
                    onTap: onRequestGroupTap,
                  ),
            vSpace,
            if (isOwns) Button(buttonText: 'Settings', onTap: onSettingsTap),
          ],
        ),
      ),
    );
  }

  Widget getImageWidget(Rx<File?> file, {String? networkImage = ''}) {
    return Obx(() {
      return SizedBox(
          height: 200.h,
          width: double.infinity,
          child: Stack(
            children: [
              (file.value != null)
                  ? Image.file(file.value!,
                      fit: BoxFit.cover, width: double.infinity)
                  : (networkImage != '')
                      ? NetworkPlainImage(
                          fit: BoxFit.cover,
                          width: double.infinity,
                          url: "${ApiConstants.baseUrl}$networkImage")
                      : Image.asset(
                          'assets/images/place_your_image.png',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
              Positioned(
                bottom: 5,
                right: 10,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 3,
                        color: Colors.white,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(50),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(2, 4),
                          color: Colors.black.withOpacity(
                            0.3,
                          ),
                          blurRadius: 3,
                        ),
                      ]),
                  child: const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Icon(Icons.add_a_photo, color: Colors.black),
                  ),
                ),
              ),
            ],
          ));
    });
  }

  createUpdateGroupView(SocialFeedController controller,
      {GroupMembersRequestResponseModel? group}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        vSpace,
        GestureDetector(
          onTap: () async {
            AppUtils.showPicker(
              context: myContext!,
              onComplete: (File? file) {
                if (file != null) {
                  controller.groupCoverImageFile.value = file;
                }
              },
            );
          },
          child: getImageWidget(controller.groupCoverImageFile,
              networkImage: controller.groupNetworkImageToUpdate),
        ),
        vSpace,
        getTextField(
            hintText: 'Group title',
            controller: controller.groupTitleNameController),
        vSpace,
        getTextField(
            hintText: 'Group description',
            controller: controller.groupDescriptionController),
        vSpace,
        Button(
          buttonText: group != null ? 'Update Group' : 'Create group',
          onTap: () {
            ///updating or creating
            controller.createUpdateGroup(group: group);
          },
        ),
        vSpace,
      ],
    );
  }

  createUpdatePostView(SocialFeedController controller,
      {SocialPostModel? socialPostModel}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        vSpace,
        GestureDetector(
          onTap: () async {
            AppUtils.showPicker(
              context: myContext!,
              onComplete: (File? file) {
                if (file != null) {
                  controller.postCoverImageFile.value = file;
                }
              },
            );
          },
          child: getImageWidget(controller.postCoverImageFile,
              networkImage: controller.postNetworkImageToUpdate),
        ),
        vSpace,
        getTextField(
            hintText: 'Post description',
            controller: controller.postDescriptionTextController),
        vSpace,
        getTextField(
            hintText: 'Post Link',
            controller: controller.postLinkTextController),
        vSpace,
        Button(
          buttonText: socialPostModel != null ? 'Update Post' : 'Create Post',
          onTap: () {
            ///updating or creating
            controller.createUpdatePost(socialPostModel: socialPostModel);
          },
        ),
        vSpace,
      ],
    );
  }

  getTextField(
      {required String hintText,
      required TextEditingController controller,
      String? validateText,
      bool validate = true,
      bool enabled = true,
      int minLines = 1,
      int maxLines = 2,
      List<TextInputFormatter> inputFormatters = const [],
      TextInputType inputType = TextInputType.text,
      validator}) {
    return MyTextField(
        controller: controller,
        enable: enabled,
        hintText: hintText,
        minLines: minLines,
        maxLines: maxLines,
        contentPadding: 20,
        keyboardType: inputType,
        inputFormatters: inputFormatters,
        focusBorderColor: AppColor.alphaGrey,
        textColor: AppColor.blackColor,
        hintColor: AppColor.blackColor,
        fillColor: AppColor.alphaGrey,
        validator: validator ??
            (String? value) => validate
                ? (value!.trim().isEmpty ? validateText ?? "Required" : null)
                : null);
  }

  Widget getIconOnLiked(int value) {
    switch (value) {
      case 0: //nutral
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.thumb_up, color: AppColor.greyColor),
              hSpace,
              const Text("Like", style: TextStyle(color: AppColor.greyColor))
            ]);
      case 1: //liked
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.thumb_up, color: AppColor.primaryBlueColor),
              hSpace,
              const Text("Like", style: TextStyle(color: AppColor.greyColor))
            ]);
      case 2: //disliked
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.thumb_down, color: AppColor.redColor),
              hSpace,
              const Text("Disliked", style: TextStyle(color: AppColor.redColor))
            ]);
      default:
        return IgnorePointer();
    }
  }

  void showBottomSheetForComments({required Rx<SocialPostModel> postModel}) {
    AppBottomSheets.showAppAlertBottomSheet(
      isFull: true,
      isDismissable: true,
      title: 'Comments',
      context: myContext!,
      child: AllCommentsView(postModel: postModel),
    );
  }

  Widget commentCommenterView({required Comments comment}) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              NetworkCircularImage(
                url: "${ApiConstants.baseUrl}${comment.userFk?.photo}",
                radius: 18,
              ),
              hSpace,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comment.userFk?.firstName ?? '-',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.textStyleBoldBodyMedium),
                    Text(comment.content ?? '-',
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.textStyleNormalBodyXSmall),
                    vSpace,
                    Row(
                      children: [
                        const Icon(
                          Icons.thumb_up,
                          size: 16,
                          color: AppColor.greyColor,
                        ),
                        hSpace,
                        hSpace,
                        const Icon(
                          Icons.reply,
                          size: 16,
                          color: AppColor.greyColor,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Text(
                formatDateTime(DateTime.tryParse(
                    comment.createdAt ?? DateTime.now().toString())),
                style: AppTextStyles.textStyleNormalBodyXSmall,
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
