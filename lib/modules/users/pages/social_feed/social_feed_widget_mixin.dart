import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/common/styles.dart';

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

  commenterCommentView() {
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
}
