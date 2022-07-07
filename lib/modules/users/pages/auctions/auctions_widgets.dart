import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/models/biding_list_response_model.dart';
import 'package:zeerac_flutter/modules/users/models/projects_response_model.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart';
import 'package:zeerac_flutter/modules/users/pages/auctions/auction_bid_detail_page.dart';
import 'package:zeerac_flutter/modules/users/pages/projects_listing/project_details_page.dart';
import 'package:zeerac_flutter/modules/users/pages/property_listing/property_detail_page.dart';
import 'package:zeerac_flutter/my_application.dart';
import 'package:zeerac_flutter/utils/app_utils.dart';
import 'package:zeerac_flutter/utils/helpers.dart';

import '../../../../common/spaces_boxes.dart';
import '../../models/acutions_listing_response_model.dart';
import '../../models/chat_user_model.dart';
import '../chat/chat_screen.dart';

mixin AuctionWidgetMixin {
  Widget auctionWidget(AuctionFileModel result) {
    String firstImage = result.photos.isEmpty
        ? ApiConstants.imageNetworkPlaceHolder
        : "${ApiConstants.baseUrl}${result.photos.first}";

    return InkWell(
      onTap: () {
        Get.toNamed(AuctionBidDetailPage.id, arguments: result);
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
                    /*Container(
                      padding: const EdgeInsets.all(4),
                      color: AppColor.alphaGrey,
                      margin: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${result.?.length ?? 0}",
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          const Icon(
                            Icons.file_copy_sharp,
                            size: 12,
                          )
                        ],
                      ),
                    )*/
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
                              result.type ?? '-',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.textStyleBoldBodyXSmall,
                            ),
                          ),
                          Row(
                            children: [
                              Text("Verified",
                                  style:
                                      AppTextStyles.textStyleNormalBodyXSmall),
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
                        "Files: ${(result.minFiles ?? '-')} - ${(result.maxFiles ?? '-')} ",
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
                      child: Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                AppUtils.dialNumber(
                                    context: myContext!,
                                    phoneNumber:
                                        result.userFk?.phoneNumber ?? '');
                              },
                              child: const Text('Call')),
                          hSpace,
                          ElevatedButton(
                              onPressed: () {
                                Get.toNamed(ChatScreen.id,
                                    arguments: ChatUserModel(
                                        otherUserId:
                                            result.userFk?.id.toString(),
                                        otherUserProfileImage:
                                            result.userFk?.photo,
                                        otherUserContact:
                                            result.userFk?.phoneNumber ?? '123',
                                        otherUserName:
                                            result.userFk?.firstName ?? ''));
                              },
                              child: const Text(
                                'Message',
                              )),
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

  Widget biddingWidget(BidModel content) {
    return InkWell(
      onTap: () {},
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: NetworkCircularImage(
                        url: content.userFk?.photo ??
                            ApiConstants.imageNetworkPlaceHolder),
                  ),
                  hSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "By :${content.userFk?.firstName ?? ''}",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Price :${content.price?.length ?? 0}",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              hSpace,

              /// information
              Row(
                children: [
                  Text('Bid range:',
                      style: AppTextStyles.textStyleBoldBodyMedium),
                  Flexible(
                      child: Row(
                    children: [
                      Text(
                        " ${(content.startingRange ?? 0).toString()} - ",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.textStyleNormalBodySmall,
                      ),
                      vSpace,
                      Text(
                        (content.endingRange ?? 0).toString(),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.textStyleNormalBodySmall,
                      ),
                    ],
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
