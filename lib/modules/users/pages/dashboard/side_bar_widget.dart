import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/fontelico_icons.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/controllers/dash_board_controller.dart';
import 'package:zeerac_flutter/modules/users/models/companies_response_model.dart';
import 'package:zeerac_flutter/modules/users/pages/login/login_page.dart';
import 'package:zeerac_flutter/modules/users/pages/user_preferences/change_user_preferences_page.dart';
import 'package:zeerac_flutter/modules/users/pages/user_profile/user_profile_page.dart';
import 'package:zeerac_flutter/utils/user_defaults.dart';

class SideBar extends GetView<DashBoardController> {
  SideBar({Key? key}) : super(key: key);
  var session = UserDefaults.getUserSession();

  @override
  Widget build(BuildContext context) {
    session = UserDefaults.getUserSession();
    return Drawer(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: session != null
                  ? InkWell(
                      onTap: () {
                        Get.toNamed(UserProfilePage.id);
                        controller.scaffoldKey.currentState?.closeDrawer();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: NetworkCircularImage(
                              clearCache: true,
                              url:
                                  "${ApiConstants.baseUrl}${session?.photo ?? ''}",
                            ),
                          ),
                          Center(
                            child: Text(
                              session?.username ?? '',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.textStyleBoldTitleLarge
                                  .copyWith(color: AppColor.whiteColor),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Button(
                      buttonText: 'Login now !',
                      textStyle: AppTextStyles.textStyleBoldSubTitleLarge
                          .copyWith(color: AppColor.whiteColor),
                      onTap: () {
                        controller.scaffoldKey.currentState?.closeDrawer();
                        Get.toNamed(LoginPage.id);
                      }),
            ),

            ///Home
            ListTile(
              leading: const Icon(Icons.home),
              selected: controller.selectedIndex.value == 0,
              title: Text('Home', style: AppTextStyles.textStyleBoldBodyMedium),
              onTap: () {
                controller.selectedIndex.value = 0;
                controller.scaffoldKey.currentState?.closeDrawer();
              },
            ),

            ///Projects
            ListTile(
              leading: const Icon(Icons.work),
              selected: controller.selectedIndex.value == 1,
              title: Text('Projects',
                  style: AppTextStyles.textStyleBoldBodyMedium),
              onTap: () {
                controller.selectedIndex.value = 1;
                controller.scaffoldKey.currentState?.closeDrawer();
              },
            ),

            ///Companies
            ListTile(
              leading: const Icon(Icons.account_balance_outlined),
              selected: controller.selectedIndex.value == 2,
              title: Text('Companies',
                  style: AppTextStyles.textStyleBoldBodyMedium),
              onTap: () {
                controller.selectedIndex.value = 2;
                controller.scaffoldKey.currentState?.closeDrawer();
              },
            ),

            ///Agents
            ListTile(
              leading: const Icon(Entypo.feather),
              selected: controller.selectedIndex.value == 3,
              title:
                  Text('Agents', style: AppTextStyles.textStyleBoldBodyMedium),
              onTap: () {
                controller.selectedIndex.value = 3;
                controller.scaffoldKey.currentState?.closeDrawer();
              },
            ),

            ///blogs
            ListTile(
              leading: const Icon(Entypo.bookmark),
              selected: controller.selectedIndex.value == 4,
              title:
                  Text('Blogs', style: AppTextStyles.textStyleBoldBodyMedium),
              onTap: () {
                controller.selectedIndex.value = 4;
                controller.scaffoldKey.currentState?.closeDrawer();
              },
            ),

            ///trends
            ListTile(
              leading: const Icon(Fontelico.spin3),
              selected: controller.selectedIndex.value == 5,
              title:
                  Text('Trends', style: AppTextStyles.textStyleBoldBodyMedium),
              onTap: () {
                controller.selectedIndex.value = 5;
                controller.scaffoldKey.currentState?.closeDrawer();
              },
            ),

            ///Tutorials
            ListTile(
              leading: const Icon(Fontelico.emo_coffee),
              selected: controller.selectedIndex.value == 6,
              title: Text('Tutorials',
                  style: AppTextStyles.textStyleBoldBodyMedium),
              onTap: () {
                if (session != null) {
                  controller.selectedIndex.value = 6;
                } else {
                  Get.toNamed(LoginPage.id);
                }
                controller.scaffoldKey.currentState?.closeDrawer();
              },
            ),

            ///User Preferences
            if (session != null)
              ListTile(
                leading: const Icon(Icons.account_balance),
                selected: controller.selectedIndex.value == 7,
                title: Text('Looking For',
                    style: AppTextStyles.textStyleBoldBodyMedium),
                onTap: () {
                  if (session != null) {
                    controller.selectedIndex.value = 7;
                  } else {
                    Get.toNamed(LoginPage.id);
                  }
                  controller.scaffoldKey.currentState?.closeDrawer();
                },
              ),

            ///Change User Preferences
            if (session != null)
              ListTile(
                leading: const Icon(Icons.account_tree),
                selected: controller.selectedIndex.value == 8,
                title: Text('Change Preferences',
                    style: AppTextStyles.textStyleBoldBodyMedium),
                onTap: () {
                  if (session != null) {
                    Get.toNamed(ChangeUserPreferencesPage.id);
                  } else {
                    Get.toNamed(LoginPage.id);
                  }
                  controller.scaffoldKey.currentState?.closeDrawer();
                },
              ),

            ///logout
            if (session != null)
              ListTile(
                leading: const Icon(Icons.power_settings_new),
                selected: controller.selectedIndex.value == 1,
                title: Text('Logout',
                    style: AppTextStyles.textStyleBoldBodyMedium),
                onTap: () async {
                  bool? result = await UserDefaults.clearAll();
                  if (result ?? false) {
                    controller.scaffoldKey.currentState?.closeDrawer();
                    Get.offAndToNamed(LoginPage.id);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
