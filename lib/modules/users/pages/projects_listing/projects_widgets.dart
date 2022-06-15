import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/models/projects_response_model.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart';
import 'package:zeerac_flutter/modules/users/pages/projects_listing/project_details_page.dart';
import 'package:zeerac_flutter/modules/users/pages/property_listing/property_detail_page.dart';
import 'package:zeerac_flutter/utils/app_utils.dart';
import 'package:zeerac_flutter/utils/helpers.dart';

import '../../../../common/spaces_boxes.dart';

Widget projectWidget(ProjectModel result) {
  String firstImage = result.logo == null
      ? ApiConstants.imageNetworkPlaceHolder
      : "${ApiConstants.baseUrl}${result.logo ?? ''}";

  return InkWell(
    onTap: () {
      Get.toNamed(ProjectDetailPage.id, arguments: result);
    },
    child: Card(
      child: SizedBox(
        height: 260.h,
        child: Row(
          children: [
            ///images
            Expanded(
              flex: 4,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  NetworkPlainImage(
                    url: firstImage,
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    color: AppColor.alphaGrey,
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${result.content?.length ?? 0}",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const Icon(
                          Icons.file_copy_sharp,
                          size: 12,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

            hSpace,

            /// information
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            result.propertyType ?? '-',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.textStyleBoldBodyXSmall,
                          ),
                        ),
                        Row(
                          children: [
                            Text("Verified",
                                style: AppTextStyles.textStyleNormalBodyXSmall),
                            hSpace,
                            const Icon(
                              Icons.verified_outlined,
                              size: 10,
                              color: AppColor.green,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  vSpace,
                  Flexible(
                    child: Text(
                      result.city ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.textStyleBoldBodyMedium,
                    ),
                  ),
                  Text(
                    result.country ?? '-',
                    style: AppTextStyles.textStyleBoldBodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Flexible(
                    child: Text(
                      "Price: ${(result.minPrice ?? '-')} - ${(result.maxPrice ?? '-')} ",
                      style: AppTextStyles.textStyleNormalBodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  /* Flexible(
                    child: Row(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.bed, size: 12),
                            Text("${result.beds ?? 0}"),
                          ],
                        ),
                        hSpace,
                        Row(
                          children: [
                            const Icon(Icons.bathtub, size: 12),
                            Text("${result.bathrooms ?? 0}"),
                          ],
                        ),
                        hSpace,
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.area_chart, size: 12),
                              Expanded(
                                  child: Text(
                                      "${result.space ?? '0'} ${result.unit ?? ''}")),
                            ],
                          ),
                        ),
                        const Icon(Icons.favorite_border),
                        hSpace,
                      ],
                    ),
                  ),*/
                  vSpace,
                  Expanded(
                    child: Opacity(
                      opacity: 0.2,
                      child: Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {}, child: const Text('Call')),
                          hSpace,
                          ElevatedButton(
                              onPressed: () {},
                              child: const Text(
                                'Message',
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget projectContentWidget(Content content) {
  String firstImage =
      ((content.files == null) || (content.files?.length ?? 0) < 1)
          ? ApiConstants.imageNetworkPlaceHolder
          : "${ApiConstants.baseUrl}${(content.files?.first.file ?? '')}";

  return InkWell(
    onTap: () {
      // Get.toNamed(ProjectDetailPage.id, arguments: result);
    },
    child: Card(
      child: SizedBox(
        height: 260.h,
        child: Row(
          children: [
            ///images
            Expanded(
              flex: 4,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  NetworkPlainImage(
                    url: firstImage,
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    color: AppColor.alphaGrey,
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${content.files?.length ?? 0}",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const Icon(
                          Icons.file_copy_sharp,
                          size: 12,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

            hSpace,

            /// information
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.title ?? '-',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.textStyleBoldBodyXSmall,
                  ),
                  vSpace,
                  Expanded(
                    child: Text(
                      content.body ?? '-',
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.textStyleBoldBodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
