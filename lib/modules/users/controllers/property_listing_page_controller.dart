import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/dio_networking/api_client.dart';
import 'package:zeerac_flutter/dio_networking/api_response.dart';
import 'package:zeerac_flutter/dio_networking/api_route.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart';
import 'package:zeerac_flutter/utils/app_pop_ups.dart';
import 'package:zeerac_flutter/utils/helpers.dart';

class PropertyListingPageController extends GetxController {
  RxBool isLoading = false.obs;

  PropertyListingResponseModel? propertiesListingModel;
  List<PropertyModel>? propertiesList;
  String? nextPageUrl;

  void initialiseValue(PropertyListingResponseModel? propertyListingModel) {
    propertiesListingModel = propertyListingModel;
    propertiesList = propertyListingModel?.results ?? [];
    nextPageUrl = propertyListingModel?.next;
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final before = notification.metrics.extentBefore;
      final max = notification.metrics.maxScrollExtent;

      if (before == max) {
        printWrapped("end of the page");
        if ((nextPageUrl ?? '').isNotEmpty) {
          loadMoreListings(
              url: nextPageUrl!,
              onComplete: (PropertyListingResponseModel propertyListingModel) {
                if (propertyListingModel.results != null) {
                  propertiesList?.addAll(propertyListingModel.results!);
                  nextPageUrl = propertyListingModel.next;
                  update();
                }
              });
        }
        // load next page
        // code here will be called only if scrolled to the very bottom
      }
    }
    return false;
  }

  void loadMoreListings({required String url, required onComplete}) {
    isLoading.value = true;
    Map<String, dynamic> body = {};
    url = url.replaceFirst('http', 'https');
    var client = APIClient(isCache: false, baseUrl: url);
    client
        .request(
            route: APIRoute(
              APIType.loadMorePropertiesList,
              body: body,
            ),
            create: () => APIResponse<PropertyListingResponseModel>(
                create: () => PropertyListingResponseModel()),
            apiFunction: loadMoreListings)
        .then((response) {
      isLoading.value = false;
      if ((response.response?.data?.count ?? 0) > 0) {
        onComplete(response.response?.data);
      } else {
        AppPopUps.showDialogContent(
            title: 'Alert',
            description: 'No result found',
            dialogType: DialogType.INFO);
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
