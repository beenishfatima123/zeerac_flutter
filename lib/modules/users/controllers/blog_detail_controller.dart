import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/dio_networking/api_client.dart';
import 'package:zeerac_flutter/dio_networking/api_response.dart';
import 'package:zeerac_flutter/dio_networking/api_route.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/models/blog_response_model.dart';

import '../../../utils/helpers.dart';

class BlogDetailController extends GetxController {
  RxBool isLoading = false.obs;

  BlogModel? blogModel;

  initValues(BlogModel? blogModel) {
    this.blogModel = blogModel;
  }
}
