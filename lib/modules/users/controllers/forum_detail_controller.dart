import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/dio_networking/api_client.dart';
import 'package:zeerac_flutter/dio_networking/api_response.dart';
import 'package:zeerac_flutter/dio_networking/api_route.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/models/forums_response_model.dart';
import 'package:zeerac_flutter/utils/user_defaults.dart';

import '../../../utils/app_pop_ups.dart';

class ForumDetailController extends GetxController {
  RxBool isLoading = false.obs;
  late ForumModel forumModel;

  TextEditingController sendReplyTextController = TextEditingController();

  void initController({required ForumModel forumModel}) {
    this.forumModel = forumModel;
  }

  void sendReplyToThread({required onComplete}) {
    isLoading.value = true;
    String? userId = UserDefaults.getCurrentUserId();
    Map<String, dynamic> body = {
      "content": sendReplyTextController.text.trim(),
      "author_fk": userId,
      "group_fk": forumModel.id.toString(),
//is_private:false
    };
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.replyToForum,
              body: body,
            ),
            create: () => APIResponse<ReplyModel>(create: () => ReplyModel()),
            apiFunction: sendReplyToThread)
        .then((response) {
      isLoading.value = false;
      ReplyModel? replyModel = response.response?.data;
      if (replyModel != null) {
        forumModel.replies?.insert(0, replyModel);
        onComplete();
      } else {
        AppPopUps.showDialogContent(
            title: 'Error',
            description: 'Failed to post reply',
            dialogType: DialogType.ERROR);
      }
    }).catchError((error) {
      isLoading.value = false;
      AppPopUps.showDialogContent(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);
    });
  }
}
