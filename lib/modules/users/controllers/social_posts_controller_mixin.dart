import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zeerac_flutter/modules/users/controllers/social_feed_controller.dart';

import '../../../dio_networking/api_client.dart';
import '../../../dio_networking/api_response.dart';
import '../../../dio_networking/api_route.dart';
import '../../../dio_networking/app_apis.dart';
import '../../../utils/app_pop_ups.dart';
import '../../../utils/helpers.dart';
import '../models/social_posts_response_model.dart';

mixin SocialPostsControllerMixin implements Loading {
  int postPageToLoad = 1;
  bool postHasNewPage = false;

  RxList<Rx<SocialPostModel>?> socialPostModelList =
      <Rx<SocialPostModel>?>[].obs;
  RxList<Rx<SocialPostModel>?> socialPostFilteredItemList =
      <Rx<SocialPostModel>?>[].obs;
  TextEditingController addNewCommentTextController = TextEditingController();

  loadPosts({bool showAlert = false}) {
    isLoading.value = true;
    printWrapped("getting social posts");
    isLoading.value = true;
    APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
        .request(
            route: APIRoute(
              APIType.getSocialPosts,
              body: {'page': postPageToLoad.toString()},
            ),
            create: () => APIResponse<SocialPostsResponseModel>(
                create: () => SocialPostsResponseModel()),
            apiFunction: loadPosts)
        .then((response) async {
      isLoading.value = false;
      if ((response.response?.data?.results?.length ?? 0) > 0) {
        if ((response.response?.data?.next ?? '').isNotEmpty) {
          postPageToLoad++;
          postHasNewPage = true;
        } else {
          postHasNewPage = false;
        }
        socialPostModelList
            .addAll(response.response!.data!.results!.map((element) {
          return element.obs;
        }));
        socialPostFilteredItemList.addAll(socialPostModelList);
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

  refreshPostList() async {
    socialPostFilteredItemList.clear();
    socialPostModelList.clear();
    postPageToLoad = 0;
    postHasNewPage = false;
    loadPosts(showAlert: true);
  }

  void addNewComment() {
    if (addNewCommentTextController.text.isNotEmpty) {}
  }
}
