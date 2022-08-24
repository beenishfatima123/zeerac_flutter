import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:zeerac_flutter/common/app_constants.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/models/group_member_requests_response_model.dart';
import 'package:zeerac_flutter/modules/users/models/social_group_response_model.dart';
import 'package:zeerac_flutter/utils/user_defaults.dart';

import '../../../../my_application.dart';
import '../../../../utils/app_utils.dart';
import '../../controllers/social_feed_controller.dart';

mixin SocialFeedWidgetMixin {
  Widget makeStory({storyImage, userImage, userName}) {
    return AspectRatio(
      aspectRatio: 1.6 / 2,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image:
              DecorationImage(image: AssetImage(storyImage), fit: BoxFit.cover),
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
                Colors.black.withOpacity(.9),
                Colors.black.withOpacity(.1),
              ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    image: DecorationImage(
                        image: AssetImage(userImage), fit: BoxFit.cover)),
              ),
              Text(
                userName,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget makeFeed({userName, userImage, feedTime, feedText, feedImage}) {
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
                Row(
                  children: <Widget>[
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage(userImage), fit: BoxFit.cover)),
                    ),
                    hSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          userName,
                          style: AppTextStyles.textStyleBoldBodyMedium
                              .copyWith(letterSpacing: 1),
                        ),
                        hSpace,
                        Text(
                          feedTime,
                          style: AppTextStyles.textStyleNormalBodySmall
                              .copyWith(color: AppColor.greyColor),
                        ),
                      ],
                    )
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.more_horiz,
                    size: 30,
                    color: AppColor.greyColor,
                  ),
                  onPressed: () {},
                )
              ],
            ),
            vSpace,
            Text(
              feedText,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.textStyleNormalBodyMedium.copyWith(),
            ),
            vSpace,
            feedImage != ''
                ? Container(
                    height: 400.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: AssetImage(feedImage), fit: BoxFit.cover)),
                  )
                : const IgnorePointer(),
            vSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    makeLike(),
                    hSpace,
                    Text(
                      "2.5K",
                      style: AppTextStyles.textStyleNormalBodyMedium
                          .copyWith(color: AppColor.greyColor),
                    )
                  ],
                ),
                Text(
                  "400 Comments",
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
                  makeLikeButton(isActive: true),
                  hSpace,
                  makeActionButton(title: 'Comments', iconData: Icons.message),
                  hSpace,
                  makeActionButton(title: 'Share', iconData: Icons.share),
                ],
              ),
            ),
            vSpace,
            previousComments(),
          ],
        ),
      ),
    );
  }

  Widget makeLike() {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white)),
      child: Center(
        child: Icon(Icons.thumb_up, size: 12, color: Colors.white),
      ),
    );
  }

  Widget makeLikeButton({isActive}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.greyColor),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.thumb_up,
              color: isActive ? Colors.blue : Colors.grey,
              size: 18,
            ),
            hSpace,
            Text(
              "Like",
              style: TextStyle(color: isActive ? Colors.blue : Colors.grey),
            )
          ],
        ),
      ),
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

  Widget previousComments() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///show if comments size is more than 100
        Text(
          'Load Previous Comments',
          style: AppTextStyles.textStyleBoldBodySmall
              .copyWith(color: AppColor.greyColor),
        ),
        vSpace,
        commenterCommentView(),
      ],
    );
  }

  Widget commenterCommentView() {
    return Container(
      child: Row(
        children: [
          NetworkCircularImage(
            url: 'url',
            radius: 18,
          ),
        ],
      ),
    );
  }

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
    return SizedBox(
      height: 200.h,
      width: double.infinity,
      child: Obx(() {
        return Stack(
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
        );
      }),
    );
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
}
