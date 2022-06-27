import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/controllers/blog_listing_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/tutorials_controller.dart';
import 'package:zeerac_flutter/modules/users/pages/blogs/blog_detail_page.dart';
import 'package:zeerac_flutter/modules/users/pages/blogs/blog_widgets.dart';
import 'package:zeerac_flutter/modules/users/pages/tutorials/tutorials_widget.dart';
import 'package:zeerac_flutter/modules/users/pages/tutorials/video_player_scoring_page.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import 'package:zeerac_flutter/utils/myAnimSearchBar.dart';
import '../../../../common/loading_widget.dart';

class TutorialsPage extends GetView<TutorialsController>
    with TutorialWidgetsMixin {
  const TutorialsPage({Key? key}) : super(key: key);
  static const id = '/TutorialsPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<TutorialsController>(
        initState: (state) {
          controller.loadTutorials();
          controller.searchController.addListener(() {
            //controller.searchFromList();
          });
        },
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                ((controller.isLoading.value == false &&
                        controller.blogsList.isEmpty))
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("No Tutorial Found",
                              style: AppTextStyles.textStyleBoldBodyMedium),
                          InkWell(
                            onTap: () {
                              controller.loadTutorials(showAlert: true);
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
                          myAppBar(goBack: false, title: 'Tutorials', actions: [
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
                                        Get.toNamed(VideoPlayerScoringPage.id,
                                            arguments: controller
                                                .filteredItemList[index]!);
                                      },
                                      child: FutureBuilder(
                                          future: tutorialListingMainWidget(
                                              controller
                                                  .filteredItemList[index]!),
                                          builder: (context,
                                              AsyncSnapshot<Widget> snapShot) {
                                            if (snapShot.data != null) {
                                              return snapShot.data!;
                                            }

                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }),
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
