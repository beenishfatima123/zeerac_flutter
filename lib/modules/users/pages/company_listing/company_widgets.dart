import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/modules/users/models/companies_response_model.dart';
import 'package:zeerac_flutter/modules/users/pages/company_listing/company_detail_page.dart';
import 'package:zeerac_flutter/modules/users/pages/projects_listing/project_details_page.dart';
import 'package:zeerac_flutter/my_application.dart';
import 'package:zeerac_flutter/utils/app_utils.dart';

import '../../../../common/common_widgets.dart';
import '../../../../common/styles.dart';
import '../../../../dio_networking/app_apis.dart';

Widget companyListingWidget(CompanyModel result) {
  String firstImage = result.logo == null
      ? ApiConstants.imageNetworkPlaceHolder
      : "${ApiConstants.baseUrl}${result.logo ?? ''}";

  return InkWell(
    onTap: () {
      Get.toNamed(CompanyDetailPage.id, arguments: result);
    },
    child: Card(
      child: SizedBox(
        height: 260.h,
        child: Row(
          children: [
            ///images
            Expanded(
              flex: 4,
              child: NetworkPlainImage(
                url: firstImage,
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
                  vSpace,
                  Flexible(
                    child: Text(
                      result.name ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.textStyleBoldBodyMedium,
                    ),
                  ),
                  Text(
                    result.email ?? '-',
                    style: AppTextStyles.textStyleBoldBodyXSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    result.areas ?? '-',
                    style: AppTextStyles.textStyleBoldBodyXSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    result.city ?? '-',
                    style: AppTextStyles.textStyleBoldBodyXSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  vSpace,
                  Flexible(
                    child: Text(
                      "${result.activeListings.toString()} Active listings",
                      style: AppTextStyles.textStyleNormalBodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  vSpace,
                  Expanded(
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            AppUtils.dialNumber(
                                phoneNumber: result.phone ?? '123',
                                context: myContext!);
                          },
                          child: const Text('Call'),
                        ),
                        hSpace,
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            'Message',
                          ),
                        ),
                      ],
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
