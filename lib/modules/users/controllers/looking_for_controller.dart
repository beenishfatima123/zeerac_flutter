import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart';
import 'package:zeerac_flutter/utils/user_defaults.dart';

import '../../../dio_networking/api_client.dart';
import '../../../dio_networking/api_response.dart';
import '../../../dio_networking/api_route.dart';
import '../../../dio_networking/app_apis.dart';
import '../../../utils/app_pop_ups.dart';
import '../../../utils/helpers.dart';
import '../models/blog_response_model.dart';

class LookingForController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController searchController = TextEditingController();
  int pageToLoad = 1;
  bool hasNewPage = false;
  RxList<PropertyModel?> filteredItemList = <PropertyModel?>[].obs;
  RxList<PropertyModel?> propertiesList = <PropertyModel>[].obs;

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final before = notification.metrics.extentBefore;
      final max = notification.metrics.maxScrollExtent;

      if (before == max) {
        if (hasNewPage) {
          printWrapped('reached at then end');
          loadPreferences();
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
      filteredItemList.addAll(propertiesList);
    } else {
      String query = searchController.text.toLowerCase();
      for (var element in propertiesList) {
        if (((element?.name ?? "null").toLowerCase()).contains(query) ||
            ((element?.city ?? "null").toLowerCase()).contains(query)) {
          filteredItemList.add(element);
        }
      }
    }
  }

  void loadPreferences({bool showAlert = false}) {
    isLoading.value = true;
    final userId = UserDefaults.getUserSession()?.id ?? -1;

    Map<String, dynamic> body = {
      "page": pageToLoad.toString(),
      "user_id": userId
    };

    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.getUserPreferenceListing,
              body: body,
            ),
            create: () => APIResponse<PropertyListingResponseModel>(
                create: () => PropertyListingResponseModel()),
            apiFunction: loadPreferences)
        .then((response) {
      isLoading.value = false;

      if ((response.response?.data?.results?.length ?? 0) > 0) {
        if ((response.response?.data?.next ?? '').isNotEmpty) {
          pageToLoad++;
          hasNewPage = true;
        } else {
          hasNewPage = false;
        }
        propertiesList.addAll(response.response!.data!.results!);
        filteredItemList.addAll(response.response!.data!.results!);
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
}
