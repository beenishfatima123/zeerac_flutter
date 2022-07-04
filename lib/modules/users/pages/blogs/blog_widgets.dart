import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/models/blog_response_model.dart';
import 'package:zeerac_flutter/utils/helpers.dart';

import '../../../../common/spaces_boxes.dart';

mixin BlogsWidgets {
  Widget getBlogWidget(BlogModel blogModel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          NetworkPlainImage(
            url: "${ApiConstants.baseUrl}${blogModel.blogPhoto}",
            height: 250.h,
            fit: BoxFit.fill,
          ),
          Container(
            padding: const EdgeInsets.all(4),
            color: AppColor.blackColor.withOpacity(0.5),
            height: 120.h,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                hSpace,
                NetworkCircularImage(
                  url: "${ApiConstants.baseUrl}${blogModel.authorPhoto}",
                  radius: 150.r,
                ),
                hSpace,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(blogModel.authorName ?? '-',
                          style: AppTextStyles.textStyleNormalBodyMedium
                              .copyWith(color: AppColor.whiteColor)),
                      Text(
                          formatDateTime(
                                  DateTime.tryParse(blogModel.createdAt ?? '-'))
                              .toString(),
                          style: AppTextStyles.textStyleNormalBodyXSmall
                              .copyWith(color: AppColor.whiteColor)),
                      Flexible(
                          child: Text(
                        blogModel.title ?? '-',
                        style: AppTextStyles.textStyleNormalBodyXSmall
                            .copyWith(color: AppColor.whiteColor),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildChipsList(List<String> chips) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return Chip(
              backgroundColor: AppColor.green,
              label: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  chips[i],
                  style: const TextStyle(color: AppColor.whiteColor),
                ),
              ));
        },
        itemCount: chips.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            width: 18,
          );
        },
        physics: const BouncingScrollPhysics(),
      ),
    );
  }
}
