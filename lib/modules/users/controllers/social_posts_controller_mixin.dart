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

  void addNewComment(
      {required SocialPostModel postModel, required completion}) {
    if (addNewCommentTextController.text.isNotEmpty) {
      isLoading.value = true;
      Map<String, dynamic> body = {
        "property_posts_fk": postModel.id.toString(),
        "user_fk": UserDefaults.getCurrentUserId() ?? '',
        "content": addNewCommentTextController.text.trim()
      };

      APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
          .request(
              route: APIRoute(
                APIType.postSocialPostComment,
                body: body,
              ),
              create: () => APIResponse<Comments>(create: () => Comments()),
              apiFunction: addNewComment)
          .then((response) {
        isLoading.value = false;

        Comments? model = response.response?.data;
        if (model != null) {
          completion(model);
          addNewCommentTextController.clear();
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
  }

  void addNewLike(
      {required SocialPostModel postModel,
      required completion,
      required bool isLiked,
      required int alreadyPresentCommentId,
      required bool isDisliked}) {
    isLoading.value = true;
    //

    Map<String, dynamic> body = {
      "property_posts_fk": postModel.id.toString(),
      "user_fk": UserDefaults.getCurrentUserId() ?? '',
      "like": isLiked,
      "dislike": isDisliked,
    };
    if (alreadyPresentCommentId != -1) {
      body['id'] = alreadyPresentCommentId;
    }
    APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
        .request(
            route: APIRoute(
              (alreadyPresentCommentId == -1)
                  ? APIType.propertyPostCommentLikes
                  : APIType.propertyPostCommentLikesPut,
              body: body,
            ),
            create: () => APIResponse<LikesModel>(create: () => LikesModel()),
            apiFunction: addNewLike)
        .then((response) {
      isLoading.value = false;

      LikesModel? model = response.response?.data;
      if (model != null) {
        completion(model);
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
}
