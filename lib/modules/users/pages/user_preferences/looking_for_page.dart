import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/controllers/blog_listing_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import 'package:zeerac_flutter/modules/users/pages/blogs/blog_detail_page.dart';
import 'package:zeerac_flutter/modules/users/pages/blogs/blog_widgets.dart';
import 'package:zeerac_flutter/modules/users/pages/property_listing/property_listing_widgets.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import 'package:zeerac_flutter/utils/myAnimSearchBar.dart';
import '../../../../common/loading_widget.dart';
import '../../controllers/looking_for_controller.dart';

class LookingForPage extends GetView<LookingForController>
    with PropertyListingWidgets {
  const LookingForPage({Key? key}) : super(key: key);
  static const id = '/LookingForPage';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: GetX<LookingForController>(
        initState: (state) {
          controller.loadPreferences();
          controller.searchController.addListener(() {
            controller.searchFromList();
          });
        },
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                ((controller.isLoading.value == false &&
                        controller.propertiesList.isEmpty))
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("No Preference Found",
                              style: AppTextStyles.textStyleBoldBodyMedium),
                          InkWell(
                            onTap: () {
                              controller.loadPreferences(showAlert: true);
                            },
                            child: Text(
                              "Refresh",
                              style: AppTextStyles.textStyleBoldBodyMedium
                                  .copyWith(
                                      decoration: TextDecoration.underline,
                                      color: AppColor.primaryBlueColor),
                            ),
                          ),
                        ],
                      ))
                    : Column(
                        children: [
                          myAppBar(
                              goBack: false,
                              title: 'Preference',
                              actions: [
                                MyAnimSearchBar(
                                    rtl: true,
                                    width: MediaQuery.of(context).size.width,
                                    textController: controller.searchController,
                                    closeSearchOnSuffixTap: true,
                                    onSuffixTap: () {
                                      controller.searchController.clear();
                                    }),
                              ]),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: NotificationListener(
                                onNotification: controller.onScrollNotification,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: controller.filteredItemList.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        /* Get.toNamed(BlogDetailPage.id,
                                      arguments: controller
                                          .filteredItemList[index]!);*/
                                      },
                                      child: propertiesWidget(
                                          controller.filteredItemList[index]!),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
