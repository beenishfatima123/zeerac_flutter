import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SocialFeedController extends GetxController {
  RxBool isLoading = false.obs;

  RxInt selectedIndex = 0.obs;

  PageController pageViewController = PageController();
}
