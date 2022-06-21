import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/dio_networking/api_client.dart';
import 'package:zeerac_flutter/dio_networking/api_response.dart';
import 'package:zeerac_flutter/dio_networking/api_route.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/models/agents_listing_response_model.dart';
import 'package:zeerac_flutter/modules/users/models/companies_response_model.dart';
import 'package:zeerac_flutter/modules/users/models/projects_response_model.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart';
import 'package:zeerac_flutter/utils/helpers.dart';

class AgentDetailController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController searchController = TextEditingController();
  RxList<PropertyModel>? agentsPropertiesList = <PropertyModel>[].obs;

  var isSliverExpanded = true.obs;
  int pageToLoad = 1;
  bool hasNewPage = false;
  AgentsModel? agentsModel;

  void initValues(AgentsModel agentsModel) {
    this.agentsModel = agentsModel;
  }

  void loadAgentzPropertiesFromServer() {
    isLoading.value = true;
    Map<String, dynamic> body = {
      "agent": agentsModel?.id.toString(),
      "page": pageToLoad.toString(),
    };

    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.agentzPropertyListing,
              body: body,
            ),
            create: () => APIResponse<PropertyListingResponseModel>(
                create: () => PropertyListingResponseModel()),
            apiFunction: loadAgentzPropertiesFromServer)
        .then((response) {
      isLoading.value = false;

      PropertyListingResponseModel? responseModel = response.response?.data;

      if (responseModel?.results != null) {
        if ((responseModel?.next ?? '').isNotEmpty) {
          pageToLoad++;
          printWrapped('has new page');
          hasNewPage = true;
        } else {
          hasNewPage = false;
        }
        agentsPropertiesList?.addAll(response.response!.data!.results!);
      }
    }).catchError((error) {
      isLoading.value = false;
    });
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final before = notification.metrics.extentBefore;
      final max = notification.metrics.maxScrollExtent;

      if (before == max) {
        if (hasNewPage) {
          printWrapped('reached at then end');
          loadAgentzPropertiesFromServer();
        }
        // load next page
        // code here will be called only if scrolled to the very bottom
      }
    }
    return false;
  }
}
