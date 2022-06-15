import 'package:get/get.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart';

import '../models/projects_response_model.dart';

class ProjectDetailController extends GetxController {
  RxBool isLoading = false.obs;
  ProjectModel? projectsResponseModel;

  void initValues(ProjectModel projectsResponseModel) {
    this.projectsResponseModel = projectsResponseModel;
  }
}
