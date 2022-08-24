import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/dio_networking/api_client.dart';
import 'package:zeerac_flutter/modules/users/controllers/social_group_controller_mixin.dart';
import 'package:zeerac_flutter/modules/users/controllers/social_posts_controller_mixin.dart';
import 'package:zeerac_flutter/modules/users/models/group_member_requests_response_model.dart';
import 'package:zeerac_flutter/modules/users/models/social_group_response_model.dart';
import 'package:zeerac_flutter/my_application.dart';
import 'package:zeerac_flutter/utils/app_pop_ups.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import 'package:zeerac_flutter/utils/user_defaults.dart';

import '../../../dio_networking/api_response.dart';
import '../../../dio_networking/api_route.dart';
import '../../../dio_networking/app_apis.dart';
import '../models/user_model.dart';

class SocialFeedController extends GetxController
    with GroupControllerMixin, SocialPostsControllerMixin {
  RxInt selectedIndex = 0.obs;

  PageController pageViewController = PageController();

  @override
  RxBool isLoading = false.obs;
}

abstract class Loading {
  RxBool isLoading = false.obs;
}
