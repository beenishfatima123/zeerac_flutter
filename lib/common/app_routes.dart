import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../modules/users/controllers/login_controller.dart';
import '../modules/users/pages/login_page.dart';

appRoutes() {
  return [
    ///admin
    GetPage(
        name: LoginPage.id,
        page: () => LoginPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<LoginController>(
            () => LoginController(),
          );
        })),
    /*  GetPage(
        name: AdminHomePage.id,
        page: () => AdminHomePage(),
        binding: BindingsBuilder(() {
          Get.put(AdminHomeScreenController());
          Get.put(AdminViewAllDriversController());
          Get.put(AdminDashBoardHomeController());
          Get.put(AdminViewAllUsersController());
          Get.put(AdminViewAllBlogsController());
          Get.put(AdminViewAllBookingsController());
          Get.put(NotificationsController());
          Get.put(ChatHomeController());
          Get.put(PromotedAdsController());
        })),*/
  ];
}
