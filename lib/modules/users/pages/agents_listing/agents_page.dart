import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/controllers/agents_listing_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/company_listing_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/projects_controller.dart';
import 'package:zeerac_flutter/modules/users/models/projects_response_model.dart';
import 'package:zeerac_flutter/modules/users/pages/agents_listing/add_new_agent_page.dart';
import 'package:zeerac_flutter/modules/users/pages/company_listing/company_listing_widgets.dart';
import 'package:zeerac_flutter/modules/users/pages/login/login_page.dart';
import 'package:zeerac_flutter/modules/users/pages/projects_listing/projects_widgets.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import 'package:zeerac_flutter/utils/myAnimSearchBar.dart';
import 'package:zeerac_flutter/utils/user_defaults.dart';
import '../../../../common/loading_widget.dart';
import 'agents_listing_widgets.dart';

class AgentsListingPage extends GetView<AgentsListingController> {
  const AgentsListingPage({Key? key}) : super(key: key);
  static const id = '/AgentsListingPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (UserDefaults.getUserSession() != null) {
            Get.toNamed(AddNewAgentPage.id);
          } else {
            Get.toNamed(LoginPage.id);
          }
        },
        elevation: 20,
        child: const Icon(Icons.add, color: AppColor.whiteColor),
      ),
      body: GetX<AgentsListingController>(
        initState: (state) {
          if (controller.agentsList.isEmpty) {
            controller.loadAgents();
            controller.searchController.addListener(() {
              controller.searchFromList();
            });
          }
        },
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                ((controller.isLoading.value == false &&
                        controller.agentsList.isEmpty))
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("No Agent Found",
                              style: AppTextStyles.textStyleBoldBodyMedium),
                          InkWell(
                            onTap: () {
                              controller.loadAgents(showAlert: true);
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
                          myAppBar(goBack: false, title: 'Agents', actions: [
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
                              padding: const EdgeInsets.all(14),
                              child: NotificationListener(
                                onNotification: controller.onScrollNotification,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: controller.filteredItemList.length,
                                  itemBuilder: (context, index) {
                                    return agentsListingWidget(
                                        controller.filteredItemList[index]!);
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
