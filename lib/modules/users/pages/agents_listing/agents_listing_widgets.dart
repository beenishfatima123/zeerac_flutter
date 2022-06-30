import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/modules/users/models/agents_listing_response_model.dart';
import 'package:zeerac_flutter/modules/users/models/chat_user_model.dart';
import 'package:zeerac_flutter/modules/users/models/companies_response_model.dart';
import 'package:zeerac_flutter/modules/users/pages/agents_listing/agent_detail_page.dart';
import 'package:zeerac_flutter/modules/users/pages/company_listing/company_detail_page.dart';
import 'package:zeerac_flutter/modules/users/pages/login/login_page.dart';
import 'package:zeerac_flutter/modules/users/pages/projects_listing/project_details_page.dart';
import 'package:zeerac_flutter/my_application.dart';
import 'package:zeerac_flutter/utils/app_utils.dart';
import 'package:zeerac_flutter/utils/user_defaults.dart';

import '../../../../common/common_widgets.dart';
import '../../../../common/styles.dart';
import '../../../../dio_networking/app_apis.dart';
import '../chat/chat_screen.dart';

Widget agentsListingWidget(AgentsModel result) {
  String firstImage = ((result.photo ?? '').isEmpty)
      ? ApiConstants.imageNetworkPlaceHolder
      : "${ApiConstants.baseUrl}${result.photo ?? ''}";

  return InkWell(
    onTap: () {
      Get.toNamed(AgentDetailPage.id, arguments: result);
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
                      result.username ?? '-',
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
                    result.company ?? '-',
                    style: AppTextStyles.textStyleBoldBodyXSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    result.country ?? '-',
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
                      "${(result.activeListingCount ?? 0).toString()} Active listings",
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
                                phoneNumber: result.phoneNumber ?? '123',
                                context: myContext!);
                          },
                          child: const Text('Call'),
                        ),
                        hSpace,
                        ElevatedButton(
                          onPressed: () {
                            if (UserDefaults.getUserSession() != null) {
                              Get.toNamed(ChatScreen.id,
                                  arguments: ChatUserModel(
                                      otherUserId: result.id!.toString(),
                                      otherUserProfileImage: firstImage,
                                      otherUserContact:
                                          result.phoneNumber ?? '123',
                                      otherUserName: result.firstName ?? ''));
                            } else {
                              Get.toNamed(LoginPage.id);
                            }
                          },
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
