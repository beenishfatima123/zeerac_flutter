import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/dio_networking/api_response.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/models/tutorial_response_model.dart';

import '../../../dio_networking/api_client.dart';
import '../../../dio_networking/api_route.dart';
import '../../../utils/app_pop_ups.dart';
import '../../../utils/helpers.dart';

class TutorialsController extends GetxController {
  RxBool isLoading = false.obs;

  RxList<TutorialResponseModel?> filteredItemList =
      <TutorialResponseModel?>[].obs;
  TextEditingController searchController = TextEditingController();
  int pageToLoad = 1;
  bool hasNewPage = false;
  RxList<TutorialResponseModel?> blogsList = <TutorialResponseModel>[].obs;

  void loadTutorials({bool showAlert = false}) {
    isLoading.value = true;
    Map<String, dynamic> body = {
      /*"page": pageToLoad.toString(),*/
    };

    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.loadTutorials,
              body: body,
            ),
            create: () => APIListResponse<TutorialResponseModel>(
                create: () => TutorialResponseModel()),
            apiFunction: loadTutorials)
        .then((response) {
      isLoading.value = false;

      if ((response.response?.data?.length ?? 0) > 0) {
        // if ((response.response?.data?.next ?? '').isNotEmpty) {
        //   pageToLoad++;
        //   hasNewPage = true;
        // } else {
        //   hasNewPage = false;
        // }
        blogsList.addAll(response.response!.data!);
        filteredItemList.addAll(response.response!.data!);
      } else {
        if (showAlert) {
          AppPopUps.showDialog(
              title: 'Alert',
              description: 'No result found',
              dialogType: DialogType.INFO);
        }
      }
    }).catchError((error) {
      isLoading.value = false;
      if (showAlert) {
        AppPopUps.showDialog(
            title: 'Error',
            description: error.toString(),
            dialogType: DialogType.ERROR);
      }
    });
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final before = notification.metrics.extentBefore;
      final max = notification.metrics.maxScrollExtent;

      if (before == max) {
        if (hasNewPage) {
          printWrapped('reached at then end');
          //  loadBlogs();
        }
        // load next page
        // code here will be called only if scrolled to the very bottom
      }
    }
    return false;
  }

  void searchFromList() {
    filteredItemList.clear();
    if (searchController.text.isEmpty) {
      filteredItemList.addAll(blogsList);
    } else {
      String query = searchController.text.toLowerCase();
      for (var element in blogsList) {
        if (((element?.courseTitle ?? "null").toLowerCase()).contains(
                query) /* ||
            ((element?.courseTitle ?? "null").toLowerCase()).contains(query)*/
            ) {
          filteredItemList.add(element);
        }
      }
    }
  }
}
