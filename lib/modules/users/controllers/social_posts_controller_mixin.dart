import 'dart:io';
import 'package:dio/dio.dart' as dio;

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zeerac_flutter/modules/users/controllers/social_feed_controller.dart';

import '../../../dio_networking/api_client.dart';
import '../../../dio_networking/api_response.dart';
import '../../../dio_networking/api_route.dart';
import '../../../dio_networking/app_apis.dart';
import '../../../my_application.dart';
import '../../../utils/app_pop_ups.dart';
import '../../../utils/helpers.dart';
import '../../../utils/user_defaults.dart';
import '../models/social_posts_response_model.dart';

mixin SocialPostsControllerMixin implements Loading {
  int postPageToLoad = 1;
  bool postHasNewPage = false;

  RxList<Rx<SocialPostModel>?> socialPostModelList =
      <Rx<SocialPostModel>?>[].obs;
  RxList<Rx<SocialPostModel>?> socialPostFilteredItemList =
      <Rx<SocialPostModel>?>[].obs;
  TextEditingController addNewCommentTextController = TextEditingController();

  ///create post
  TextEditingController postDescriptionTextController = TextEditingController();
  TextEditingController postLinkTextController = TextEditingController();

  Rxn<File?> postCoverImageFile = Rxn<File>();
  String postNetworkImageToUpdate = '';

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

  void createUpdatePost({SocialPostModel? socialPostModel}) async {
    if (postDescriptionTextController.text.isEmpty) {
      AppPopUps.showSnackBar(message: 'Enter description', context: myContext!);
      return;
    }
    // if (postLinkTextController.text.isEmpty) {
    //   AppPopUps.showSnackBar(message: 'Enter description', context: myContext!);
    //   return;
    // }

    ///to close bottomsheet
    Get.back();

    isLoading.value = true;
    Map<String, dynamic> dataMap = {};
    if (postCoverImageFile.value != null) {
      dataMap['property_post_image'] = await dio.MultipartFile.fromFile(
          postCoverImageFile.value!.path,
          filename: "postImage.png");
    }
    dataMap['description'] = postDescriptionTextController.text.trim();
    dataMap['link'] = postLinkTextController.text.trim();

    ///updating or creating....
    if (socialPostModel == null) {
      dataMap['user_fk'] = UserDefaults.getCurrentUserId() ?? '';
    }

    //dataMap['group_id'] = 'ceo_group';

    var data = dio.FormData.fromMap(dataMap);
    String url = socialPostModel == null
        ? ApiConstants.baseUrl
        : "${ApiConstants.baseUrl}${ApiConstants.socialPosts}/${socialPostModel.id.toString()}/";

    var client = APIClient(isCache: false, baseUrl: url);
    client
        .request(
            route: APIRoute(
              socialPostModel == null
                  ? APIType.createSocialPosts
                  : APIType.updateSocialPosts,
              body: data,
            ),
            create: () => APIResponse(decoding: false),
            apiFunction: createUpdatePost)
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
      isLoading.value = false;
      AppPopUps.showDialogContent(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);
      return Future.value(null);
    });
  }

  void addNewComment() {
    if (addNewCommentTextController.text.isNotEmpty) {}
  }
}
