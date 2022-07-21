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
    return InkWell(
      onTap: () {
        Get.toNamed(ForumDetailPage.id, arguments: forum);
      },
      child: Card(
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
                        child: Icon(
                          Icons.reply,
                          size: 150.r,
                          color: AppColor.primaryBlueColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget forumReplyContainer({required ReplyModel replyModel}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NetworkCircularImage(
                url: replyModel.authorFk?.photo ??
                    ApiConstants.imageNetworkPlaceHolder,
                radius: 120.r),
            hSpace,
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(replyModel.authorFk?.firstName ?? '-',
                      style: AppTextStyles.textStyleBoldBodyMedium),
                  Text(replyModel.content ?? '-',
                      style: AppTextStyles.textStyleNormalBodyXSmall),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite_border,
                              size: 70.r,
                            ),
                            Flexible(
                              child: Text("${replyModel.likesCount ?? 0}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: AppTextStyles.textStyleBoldBodyXSmall),
                            )
                          ],
                        ),
                      ),
                      /* Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons
                              .person_pin_circle_outlined,
                          size: 100.r,
                        ),
                      */ /*  Flexible(
                          child: Text(
                              "${controller.forumModel.repliesCount ?? 0}",
                              overflow:
                              TextOverflow
                                  .ellipsis,
                              maxLines: 1,
                              style: AppTextStyles
                                  .textStyleBoldBodyXSmall),
                        )*/ /*
                      ],
                    ),
                  ),*/
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        const Divider(),
        vSpace,
      ],
    );
  }
}
