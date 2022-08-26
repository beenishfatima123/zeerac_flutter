import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/models/group_member_requests_response_model.dart';
import 'package:zeerac_flutter/modules/users/pages/social_feed/social_feed_widget_mixin.dart';
import 'package:zeerac_flutter/my_application.dart';
import 'package:zeerac_flutter/utils/app_alert_bottom_sheet.dart';

import '../../../../common/common_widgets.dart';
import '../../../../common/spaces_boxes.dart';
import '../../../../utils/user_defaults.dart';
import '../../controllers/social_feed_controller.dart';

class GroupsView extends GetView<SocialFeedController>
    with SocialFeedWidgetMixin {
  static const id = '/GroupsView';

  GroupsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ///search bar
          controller.socialGroupFilteredItemList.isNotEmpty
              ? Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey[200]),
                        child: const TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
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
                        _showCreateNewGroupBottomSheet();
                      },
                      child: Icon(
                        Icons.add_circle,
                        color: Colors.grey[800],
                        size: 30,
                      ),
                    )
                  ],
                )
              : Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(20),
                  child: InkWell(
                    onTap: () {
                      controller.loadGroups();
                    },
                    child: Text(
                      'no result found refresh?',
                      style: AppTextStyles.textStyleBoldSubTitleLarge,
                    ),
                  ),
                ),
          vSpace,
          Expanded(
            child: RefreshIndicator(
              onRefresh: () {
                controller.refreshGroupList();
                return Future.delayed(const Duration(seconds: 2));
              },
              child: NotificationListener(
                onNotification: controller.groupsOnScrollNotification,
                child: ListView.builder(
                  itemCount: controller.socialGroupFilteredItemList.length,
                  physics: const BouncingScrollPhysics(),
                  reverse: true,
                  itemBuilder: (context, index) {
                    var socialGroupModel = controller
                        .socialGroupFilteredItemList
                        .elementAt(index)!;
                    bool isOwns = (socialGroupModel.adminFk?.id.toString() ==
                        UserDefaults.getCurrentUserId());
                    return getGroupView(
                        groupModel: socialGroupModel,
                        isOwns: isOwns,
                        onRequestGroupTap: () {
                          controller.requestGroupJoin(group: socialGroupModel);
                        },
                        onViewGroupTap: () {
                          ///view group...
                        },
                        onSettingsTap: () {
                          controller.getJoinRequestsOfGroup(
                            group: socialGroupModel,
                            onComplete: (GroupMembersRequestResponseModel?
                                groupsMemberResponseModel) {
                              _showSettingBottomSheet(
                                  groupsMemberResponseModel);
                            },
                          );
                        });
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showCreateNewGroupBottomSheet() {
    controller.groupCoverImageFile.value = null;
    controller.groupTitleNameController.clear();
    controller.groupDescriptionController.clear();
    controller.groupNetworkImageToUpdate = '';

    ///creating group
    AppBottomSheets.showAppAlertBottomSheet(
        context: myContext!,
        isFull: true,
        isDismissable: true,
        title: "Create new group",
        child: createUpdateGroupView(controller));
  }

  void _showSettingBottomSheet(
      GroupMembersRequestResponseModel? groupsMemberResponseModel) {
    ///settings groups information
    controller.groupCoverImageFile.value = null;
    controller.groupTitleNameController.text =
        groupsMemberResponseModel?.groupName ?? '';
    controller.groupDescriptionController.text =
        groupsMemberResponseModel?.description ?? '';
    controller.groupNetworkImageToUpdate =
        groupsMemberResponseModel?.groupPhoto ?? '';

    AppBottomSheets.showAppAlertBottomSheet(
      context: myContext!,
      isFull: true,
      isDismissable: true,
      title: "Settings",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///updating group
          createUpdateGroupView(controller, group: groupsMemberResponseModel),
          const Divider(),
          Text('Joining requests',
              style: AppTextStyles.textStyleBoldBodyMedium),
          const Divider(),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount:
                  groupsMemberResponseModel?.membersRequests?.length ?? 0,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                var requestedMember = groupsMemberResponseModel?.membersRequests
                    ?.elementAt(index);
                return Card(
                    child: SizedBox(
                  height: 150.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: NetworkCircularImage(
                            radius: 26,
                            url:
                                "${ApiConstants.baseUrl}${requestedMember?.memberPhoto ?? ''}"),
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(requestedMember?.memberName ?? '',
                              style: AppTextStyles.textStyleBoldBodyMedium),
                          vSpace,
                          Flexible(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Button(
                                    height: 60.h,
                                    padding: 0,
                                    color: AppColor.greenColor,
                                    buttonText: 'Accept request',
                                    onTap: () {
                                      controller.putMemberJoinRequest(
                                          requestedMember: requestedMember!,
                                          isApproved: true);
                                    },
                                  ),
                                ),
                                hSpace,
                                Flexible(
                                  child: Button(
                                    height: 60.h,
                                    padding: 0,
                                    color: AppColor.redColor,
                                    buttonText: 'Reject request',
                                    onTap: () {
                                      controller.putMemberJoinRequest(
                                          requestedMember: requestedMember!,
                                          isApproved: false);
                                    },
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ))
                    ],
                  ),
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
