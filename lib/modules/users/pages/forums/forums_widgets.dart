import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/pages/forums/forum_detail_page.dart';

import '../../../../common/spaces_boxes.dart';
import '../../models/forums_response_model.dart';

mixin ForumWidgetsMixin {
  Widget forumInfoWidget({required ForumModel forum}) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(30.r),
        margin: EdgeInsets.all(10.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NetworkCircularImage(
                radius: 180.r, url: ApiConstants.imageNetworkPlaceHolder),
            hSpace,
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  forum.title ?? '-',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.textStyleBoldBodySmall,
                ),
                Text(
                  forum.content ?? '-',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.textStyleNormalBodySmall,
                ),
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
                          child: Text("${forum.likesCount ?? 0}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: AppTextStyles.textStyleBoldBodyXSmall),
                        )
                      ],
                    )),
                    Expanded(
                        child: Row(
                      children: [
                        Icon(
                          Icons.person_pin_circle_outlined,
                          size: 100.r,
                        ),
                        Flexible(
                          child: Text("${forum.repliesCount ?? 0}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: AppTextStyles.textStyleBoldBodyXSmall),
                        )
                      ],
                    )),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(ForumDetailPage.id, arguments: forum);
                        },
                        child: Icon(
                          Icons.reply,
                          size: 150.r,
                          color: AppColor.primaryBlueColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
