import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/dio_networking/api_client.dart';
import 'package:zeerac_flutter/dio_networking/api_response.dart';
import 'package:zeerac_flutter/dio_networking/api_route.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/models/projects_response_model.dart';
import 'package:zeerac_flutter/utils/app_pop_ups.dart';

import '../../../utils/helpers.dart';
import '../models/acutions_listing_response_model.dart';

class AuctionsListingController extends GetxController {
  RxBool isLoading = false.obs;
  int pageToLoad = 1;
  bool hasNewPage = false;

  TextEditingController searchController = TextEditingController();
  RxList<AuctionFileModel?> auctionsFileList = <AuctionFileModel?>[].obs;
  RxList<AuctionFileModel?> filteredItemList = <AuctionFileModel?>[].obs;

  void searchFromList() {
    filteredItemList.clear();
    if (searchController.text.isEmpty) {
      filteredItemList.addAll(auctionsFileList);
    } else {
      String query = searchController.text.toLowerCase();
      for (var element in auctionsFileList) {
        if (((element?.description ?? "null").toLowerCase()).contains(query) ||
            ((element?.city ?? "null").toLowerCase()).contains(query) ||
            ((element?.country ?? "null").toLowerCase()).contains(query)) {
          filteredItemList.add(element);
        }
      }
    }
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final before = notification.metrics.extentBefore;
      final max = notification.metrics.maxScrollExtent;

      if (before == max) {
        printWrapped("end of the page");
        if (hasNewPage) {
          loadAuctionsFile(showAlert: true);
        } // load next page
        // code here will be called only if scrolled to the very bottom
      }
    }
    return false;
  }

  ///loading projects when app starts
  Future<void> loadAuctionsFile({bool showAlert = false}) async {
    isLoading.value = true;

    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.userPropertyFiles,
              body: {"page": pageToLoad},
            ),
            create: () => APIResponse<AuctionsListingResponseModel>(
                create: () => AuctionsListingResponseModel()),
            apiFunction: loadAuctionsFile)
        .then((response) {
      isLoading.value = false;
      if ((response.response?.data?.results?.length ?? 0) > 0) {
        if ((response.response?.data?.next ?? '').isNotEmpty) {
          pageToLoad++;
          hasNewPage = true;
        } else {
          hasNewPage = false;
        }
        auctionsFileList.addAll(response.response!.data!.results!);
        filteredItemList.addAll(response.response!.data!.results!);
      } else {
        if (showAlert) {
          AppPopUps.showDialogContent(
              title: 'Alert',
              description: 'No result found',
              dialogType: DialogType.INFO);
        }
      }
      return;
    }).catchError((error) {
      isLoading.value = false;

      ///not showing any dialog because this method will be called on the app start when controller gets initialized
      if (showAlert) {
        AppPopUps.showDialogContent(
            title: 'Error',
            description: error.toString(),
            dialogType: DialogType.ERROR);
      }
      return;
    });
  }

  Future<void> refreshList() async {
    auctionsFileList.clear();
    filteredItemList.clear();
    pageToLoad = 1;
    hasNewPage = false;
    return await loadAuctionsFile(showAlert: true);
  }
}
