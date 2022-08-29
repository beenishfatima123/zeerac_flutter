import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/modules/users/models/social_posts_response_model.dart';
import 'package:zeerac_flutter/modules/users/pages/social_feed/social_feed_widget_mixin.dart';
import 'package:zeerac_flutter/modules/users/pages/social_feed/widgets/post_feed_widget.dart';
import 'package:zeerac_flutter/utils/helpers.dart';

import '../../../../common/spaces_boxes.dart';
import '../../../../common/styles.dart';
import '../../../../my_application.dart';
import '../../../../utils/app_alert_bottom_sheet.dart';
import '../../controllers/social_feed_controller.dart';
import '../../models/group_member_requests_response_model.dart';

class ViewGroupsPostsPage extends GetView<SocialFeedController>
    with SocialFeedWidgetMixin {
  static const id = '/ViewGroupsPostsPage';

  ViewGroupsPostsPage({Key? key, required this.groupInfoResponseModel})
      : super(key: key);

  final GroupInfoResponseModel? groupInfoResponseModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(
          goBack: true, title: groupInfoResponseModel?.groupName ?? '-'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ///search bar
            (groupInfoResponseModel?.membersPosts ?? []).isNotEmpty
                ? Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey[200]),
                          child: const TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                              hintText: "Search",
                            ),
                          ),
                        ),
                      ),
                      hSpace,
                      InkWell(
                        onTap: () {
                          _showPostCreateUpdateBottomSheet();
                        },
                        child: const Icon(
                          Icons.camera_alt,
                          color: AppColor.greyColor,
                          size: 30,
                        ),
                      )
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        'no post found?',
                        style: AppTextStyles.textStyleBoldSubTitleLarge,
                      ),
                    ),
                  ),
            vSpace,

            Expanded(
              child: ListView.builder(
                itemCount: groupInfoResponseModel?.membersPosts?.length ?? 0,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return PostFeedWidget(
                      onViewMoreTap: () {
                        print("on image tap");
                        _showPostCreateUpdateBottomSheet(
                            socialPostModel: groupInfoResponseModel
                                ?.membersPosts
                                ?.elementAt(index));
                      },
                      postModel: (groupInfoResponseModel?.membersPosts
                              ?.elementAt(index))!
                          .obs);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showPostCreateUpdateBottomSheet({SocialPostModel? socialPostModel}) {
    ///settings groups information
    controller.postCoverImageFile.value = null;

    controller.postDescriptionTextController.text =
        socialPostModel?.description ?? '';
    controller.postLinkTextController.text = socialPostModel?.link ?? '';
    controller.postNetworkImageToUpdate =
        socialPostModel?.propertyPostImage ?? '';

    AppBottomSheets.showAppAlertBottomSheet(
        context: myContext!,
        isFull: true,
        isDismissable: true,
        title: "Posts",
        child:
            createUpdatePostView(controller, socialPostModel: socialPostModel));
  }
}
