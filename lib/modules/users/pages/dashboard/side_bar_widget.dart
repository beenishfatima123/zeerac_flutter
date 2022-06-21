import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/controllers/dash_board_controller.dart';
import 'package:zeerac_flutter/utils/user_defaults.dart';

class SideBar extends GetView<DashBoardController> {
  SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Center(
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 50.0,
                  ),
                ),
                Center(
                  child: Text(
                    "User",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.textStyleBoldTitleLarge,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            selected: controller.selectedIndex.value == 0,
            title: Text('Home', style: AppTextStyles.textStyleBoldBodyMedium),
            onTap: () {
              controller.selectedIndex.value = 0;
              controller.scaffoldKey.currentState?.closeDrawer();
            },
          ),
          ListTile(
            leading: const Icon(Icons.work),
            selected: controller.selectedIndex.value == 1,
            title:
                Text('Projects', style: AppTextStyles.textStyleBoldBodyMedium),
            onTap: () {
              controller.selectedIndex.value = 1;
              controller.scaffoldKey.currentState?.closeDrawer();
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_outlined),
            selected: controller.selectedIndex.value == 2,
            title:
                Text('Companies', style: AppTextStyles.textStyleBoldBodyMedium),
            onTap: () {
              controller.selectedIndex.value = 2;
              controller.scaffoldKey.currentState?.closeDrawer();
            },
          ),
          ListTile(
            leading: const Icon(Entypo.feather),
            selected: controller.selectedIndex.value == 3,
            title: Text('Agents', style: AppTextStyles.textStyleBoldBodyMedium),
            onTap: () {
              controller.selectedIndex.value = 3;
              controller.scaffoldKey.currentState?.closeDrawer();
            },
          ),
          IgnorePointer(
            ignoring: true,
            child: ListTile(
              leading: const Icon(Icons.logout),
              selected: controller.selectedIndex.value == 1,
              title:
                  Text('Logout', style: AppTextStyles.textStyleBoldBodyMedium),
              onTap: () {
                UserDefaults.clearAll();
                controller.scaffoldKey.currentState?.closeDrawer();
              },
            ),
          ),
        ],
      ),
    );
  }
}
