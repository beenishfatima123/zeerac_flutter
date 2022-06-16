import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/dio_networking/api_client.dart';
import 'package:zeerac_flutter/dio_networking/api_response.dart';
import 'package:zeerac_flutter/dio_networking/api_route.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/models/companies_response_model.dart';
import 'package:zeerac_flutter/modules/users/models/projects_response_model.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart';
import 'package:zeerac_flutter/utils/helpers.dart';

class CompanyDetailController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController searchController = TextEditingController();
  CompanyModel? companyModel;

  var isSliverExpanded = true.obs;
  int pageToLoadForCompanyProject = 1;

  RxList<PropertyModel>? companiesPropertiesList = <PropertyModel>[].obs;

  void initValues(CompanyModel companyModel) {
    this.companyModel = companyModel;
  }

  int pageToLoad = 1;
  bool hasNewPage = false;

  void loadCompanyzPropertiesFromServer() {
    isLoading.value = true;
    Map<String, dynamic> body = {
      "company": companyModel?.id.toString(),
      "page": pageToLoad.toString(),
    };

    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.loadCompanyPropertiesListing,
              body: body,
            ),
            create: () => APIResponse<PropertyListingResponseModel>(
                create: () => PropertyListingResponseModel()),
            apiFunction: loadCompanyzPropertiesFromServer)
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
        companiesPropertiesList?.addAll(response.response!.data!.results!);
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
          loadCompanyzPropertiesFromServer();
        }
        // load next page
        // code here will be called only if scrolled to the very bottom
      }
    }
    return false;
  }
}
