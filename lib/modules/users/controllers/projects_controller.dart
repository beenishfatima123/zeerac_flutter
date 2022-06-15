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

class ProjectsController extends GetxController {
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    print("on init project controller");
    super.onInit();
  }

  RxList<ProjectModel> projectsList = <ProjectModel>[].obs;

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final before = notification.metrics.extentBefore;
      final max = notification.metrics.maxScrollExtent;

      if (before == max) {
        printWrapped("end of the page");

        // load next page
        // code here will be called only if scrolled to the very bottom
      }
    }
    return false;
  }

  ///loading projects when app starts
  void loadProjects({bool showAlert = false}) {
    isLoading.value = true;
    Map<String, dynamic> body = {};
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.loadProjects,
              body: body,
            ),
            create: () => APIResponse<ProjectsResponseModel>(
                create: () => ProjectsResponseModel()),
            apiFunction: loadProjects)
        .then((response) {
      isLoading.value = false;
      if ((response.response?.data?.results?.length ?? 0) > 0) {
        projectsList.clear();
        projectsList.addAll(response.response!.data!.results!);
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

      ///not showing any dialog because this method will be called on the app start when controller gets initialized
      if (showAlert) {
        AppPopUps.showDialog(
            title: 'Error',
            description: error.toString(),
            dialogType: DialogType.ERROR);
      }
      return Future.value(null);
    });
  }
}
