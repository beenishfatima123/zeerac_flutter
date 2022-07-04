import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/languages.dart';
import 'package:zeerac_flutter/modules/users/controllers/dash_board_controller.dart';
import 'package:zeerac_flutter/modules/users/pages/agents_listing/agents_page.dart';
import 'package:zeerac_flutter/modules/users/pages/blogs/blog_listing_page.dart';
import 'package:zeerac_flutter/modules/users/pages/company_listing/company_listing_page.dart';
import 'package:zeerac_flutter/modules/users/pages/dashboard/side_bar_widget.dart';
import 'package:zeerac_flutter/modules/users/pages/home/home_page.dart';
import 'package:zeerac_flutter/modules/users/pages/tutorials/tutorials_page.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import '../../../../common/common_widgets.dart';
import '../../../../common/loading_widget.dart';
import '../../../../common/styles.dart';
import '../../../../utils/app_pop_ups.dart';
import '../projects_listing/projects_page.dart';
import '../trends/trends_page.dart';
import '../user_preferences/looking_for_page.dart';

class DashBoardPage extends GetView<DashBoardController> {
  DashBoardPage({Key? key}) : super(key: key);
  static const id = '/DashBoardPage';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await AppPopUps.showConfirmDialog(
            title: 'Confirm',
            message: 'Are you sure to exit from the app',
            onSubmit: () {
              Navigator.pop(context, true);
            });
      },
      child: Scaffold(
        key: controller.scaffoldKey,
        appBar: AppBar(
          title: Text("Zeerac", style: AppTextStyles.textStyleBoldTitleLarge),
          backgroundColor: AppColor.whiteColor,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: AppColor.primaryBlueColor),
            onPressed: () => controller.scaffoldKey.currentState?.openDrawer(),
          ),
          actions: [
            SizedBox(
              width: 650.w,
              child: MyDropDown(
                isDense: false,
                leftPadding: 0,
                rightPadding: 0,
                borderColor: AppColor.whiteColor,
                value: controller.languageName.value,
                textColor: AppColor.blackColor,
                onChange: (value) {
                  Languages.updateLocale(value);
                },
                items: Languages.languages,
              ),
            )
          ],
        ),
        drawer: SideBar(),
        body: GetX<DashBoardController>(
            initState: (state) {},
            builder: (_) {
              return SafeArea(
                child: IndexedStack(
                    index: controller.selectedIndex.value,
                    children: [
                      HomePage(),
                      const ProjectsPage(),
                      const CompanyListingPage(),
                      const AgentsListingPage(),
                      const BlogListingPage(),
                      TrendsPage(),
                      const TutorialsPage(),
                      const LookingForPage()
                    ]),
              );
            }),
      ),
    );
  }
}
