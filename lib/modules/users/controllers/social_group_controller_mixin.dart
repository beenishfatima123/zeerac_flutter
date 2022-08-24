import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/dio_networking/api_client.dart';
import 'package:zeerac_flutter/modules/users/controllers/social_feed_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/social_group_controller_mixin.dart';
import 'package:zeerac_flutter/modules/users/models/group_member_requests_response_model.dart';
import 'package:zeerac_flutter/modules/users/models/social_group_response_model.dart';
import 'package:zeerac_flutter/my_application.dart';
import 'package:zeerac_flutter/utils/app_pop_ups.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import 'package:zeerac_flutter/utils/user_defaults.dart';

import '../../../dio_networking/api_response.dart';
import '../../../dio_networking/api_route.dart';
import '../../../dio_networking/app_apis.dart';
import '../models/user_model.dart';

mixin GroupControllerMixin implements Loading {
//  RxBool isLoading = false.obs;

  ///.................................Groups......................../////

  int groupPageToLoad = 1;
  bool groupHasNewPage = false;

  Rxn<File?> groupCoverImageFile = Rxn<File>();

  TextEditingController groupDescriptionController = TextEditingController();

  TextEditingController groupTitleNameController = TextEditingController();

  RxList<SocialGroupModel?> socialGroupModelList = <SocialGroupModel?>[].obs;
  RxList<SocialGroupModel?> socialGroupFilteredItemList =
      <SocialGroupModel?>[].obs;

  String groupNetworkImageToUpdate = '';

  void createUpdateGroup({GroupMembersRequestResponseModel? group}) async {
    if (groupTitleNameController.text.isEmpty) {
      AppPopUps.showSnackBar(message: 'Enter title', context: myContext!);
      return;
    }
    if (groupDescriptionController.text.isEmpty) {
      AppPopUps.showSnackBar(message: 'Enter description', context: myContext!);
      return;
    }
    Get.back();

    isLoading.value = true;
    Map<String, dynamic> dataMap = {};
    if (groupCoverImageFile.value != null) {
      dataMap['group_photo'] = await dio.MultipartFile.fromFile(
          groupCoverImageFile.value!.path,
          filename: "group_cover.png");
    }
    dataMap['group_name'] = groupTitleNameController.text.trim();
    dataMap['description'] = groupDescriptionController.text.trim();

    ///updating or creating....
    if (group == null) {
      dataMap['members'] = UserDefaults.getCurrentUserId() ?? '';
      dataMap['admin_fk'] = UserDefaults.getCurrentUserId() ?? '';
    }

    //dataMap['group_id'] = 'ceo_group';

    var data = dio.FormData.fromMap(dataMap);
    print(data.toString());
    String url = group == null
        ? ApiConstants.baseUrl
        : "${ApiConstants.baseUrl}${ApiConstants.socialGroups}/${group.id.toString()}/";

    var client = APIClient(isCache: false, baseUrl: url);
    client
        .request(
            route: APIRoute(
              group == null
                  ? APIType.createSocialGroup
                  : APIType.updateSocialGroup,
              body: data,
            ),
            create: () => APIResponse(decoding: false),
            apiFunction: createUpdateGroup)
        .then((response) async {
      isLoading.value = false;

      if ((response.response?.success ?? false)) {
        AppPopUps.showDialogContent(
            title: 'Success', dialogType: DialogType.SUCCES);
      } else {
        AppPopUps.showDialogContent(
            title: 'Error', dialogType: DialogType.ERROR);
      }
    }).catchError((error) {
      print(error);
      isLoading.value = false;
      AppPopUps.showDialogContent(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);
      return Future.value(null);
    });
  }

  void loadGroups({bool showAlert = false}) async {
    printWrapped("getting social groups");
    isLoading.value = true;

    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.getAllSocialGroups,
              body: {'page': groupPageToLoad.toString()},
            ),
            create: () => APIResponse<SocialGroupsResponseModel>(
                create: () => SocialGroupsResponseModel()),
            apiFunction: loadGroups)
        .then((response) async {
      isLoading.value = false;
      if ((response.response?.data?.results?.length ?? 0) > 0) {
        if ((response.response?.data?.next ?? '').isNotEmpty) {
          groupPageToLoad++;
          groupHasNewPage = true;
        } else {
          groupHasNewPage = false;
        }
        socialGroupModelList.addAll(response.response!.data!.results!);
        socialGroupFilteredItemList.addAll(response.response!.data!.results!);
      } else {
        if (showAlert) {
          AppPopUps.showDialogContent(
              title: 'Alert',
              description: 'No result found',
              dialogType: DialogType.INFO);
        }
      }
    }).catchError((error) {
      print(error);
      isLoading.value = false;
      AppPopUps.showDialogContent(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);
      return Future.value(null);
    });
  }

  bool groupsOnScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final before = notification.metrics.extentBefore;
      final max = notification.metrics.maxScrollExtent;

      if (before == max) {
        printWrapped("end of the page");
        if (groupHasNewPage) {
          loadGroups();
        } // load next page
        // code here will be called only if scrolled to the very bottom
      }
    }
    return false;
  }

  refreshGroupList() async {
    socialGroupFilteredItemList.clear();
    socialGroupModelList.clear();
    groupPageToLoad = 0;
    groupHasNewPage = false;
    loadGroups();
  }

  void getJoinRequestsOfGroup(
      {required SocialGroupModel group, required onComplete}) {
    printWrapped("getting social groups");
    isLoading.value = true;

    APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
        .request(
            route: APIRoute(
              APIType.getOneSocialGroupById,
              body: {'id': group.id},
            ),
            create: () => APIResponse<GroupMembersRequestResponseModel>(
                create: () => GroupMembersRequestResponseModel()),
            apiFunction: getJoinRequestsOfGroup)
        .then((response) async {
      isLoading.value = false;
      onComplete(response.response?.data);
    }).catchError((error) {
      print(error);
      isLoading.value = false;
      AppPopUps.showDialogContent(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);
      return Future.value(null);
    });
  }

  void putMemberJoinRequest(
      {required MembersRequests requestedMember, required bool isApproved}) {
    APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
        .request(
            route: APIRoute(
              APIType.socialGroupMemberRequestUpdate,
              body: {'id': requestedMember.id, 'approved': isApproved},
            ),
            create: () => APIResponse(decoding: false),
            apiFunction: putMemberJoinRequest)
        .then((response) async {
      isLoading.value = false;
      if ((response.response?.success ?? false)) {
        AppPopUps.showDialogContent(
            title: 'Success', dialogType: DialogType.SUCCES);
      } else {
        AppPopUps.showDialogContent(
            title: 'Error', dialogType: DialogType.ERROR);
      }
    }).catchError((error) {
      print(error);
      isLoading.value = false;
      AppPopUps.showDialogContent(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);
      return Future.value(null);
    });
  }

  void requestGroupJoin({required SocialGroupModel group}) {
    isLoading.value = true;
    Map<String, dynamic> body = {
      'group_fk': group.id.toString(),
      'member_fk': UserDefaults.getCurrentUserId().toString()
    };
    APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
        .request(
            route: APIRoute(
              APIType.requestJoinGroup,
              body: body,
            ),
            create: () => APIResponse(decoding: false),
            apiFunction: requestGroupJoin)
        .then((response) async {
      isLoading.value = false;
      if ((response.response?.success ?? false)) {
        AppPopUps.showDialogContent(
            title: 'Success', dialogType: DialogType.SUCCES);
      } else {
        AppPopUps.showDialogContent(
            title: 'Error', dialogType: DialogType.ERROR);
      }
    }).catchError((error) {
      print(error);
      isLoading.value = false;
      AppPopUps.showDialogContent(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);
      return Future.value(null);
    });
  }
}
