import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:zeerac_flutter/modules/users/controllers/dash_board_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/projects_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/search_filter_listing_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/signup_controller.dart';
import 'package:zeerac_flutter/modules/users/pages/dashboard/dashboard_page.dart';
import 'package:zeerac_flutter/modules/users/pages/home/search_filter_listing_page.dart';
import 'package:zeerac_flutter/modules/users/pages/sign_up/sign_up_page.dart';

import '../modules/users/controllers/login_controller.dart';
import '../modules/users/pages/login/login_page.dart';

appRoutes() {
  return [
    GetPage(
        name: LoginPage.id,
        page: () => LoginPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<LoginController>(
            () => LoginController(),
          );
        })),
    GetPage(
        name: SignupPage.id,
        page: () => const SignupPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<SignupController>(
            () => SignupController(),
          );
        })),
    GetPage(
        name: DashBoardPage.id,
        page: () => DashBoardPage(),
        binding: BindingsBuilder(() {
          Get.put(DashBoardController());
          Get.put(HomeController());
          Get.put(ProjectsController());
        })),
    GetPage(
        name: SearchFilterListingPage.id,
        page: () => SearchFilterListingPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<SearchFilterListingController>(
            () => SearchFilterListingController(),
          );
        })),
  ];
}
