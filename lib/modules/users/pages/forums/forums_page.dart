import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/controllers/auctions_listing_controller.dart';
import 'package:zeerac_flutter/modules/users/models/forums_response_model.dart';
import 'package:zeerac_flutter/modules/users/pages/forums/forums_widgets.dart';
import 'package:zeerac_flutter/utils/app_alert_bottom_sheet.dart';
import 'package:zeerac_flutter/utils/app_pop_ups.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import 'package:zeerac_flutter/utils/myAnimSearchBar.dart';
import '../../../../common/app_constants.dart';
import '../../../../common/common_widgets.dart';
import '../../../../common/loading_widget.dart';
import '../../controllers/forums_page_controller.dart';
import '../auctions/auction_create_page.dart';
import '../auctions/auctions_widgets.dart';

class ForumsPage extends GetView<ForumsPageController> with ForumWidgetsMixin {
  const ForumsPage({Key? key}) : super(key: key);
  static const id = '/ForumsPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheet(context);
        },
        child: const Icon(Icons.add, color: AppColor.whiteColor),
      ),
      body: GetX<ForumsPageController>(
        initState: (state) {
          controller.selectedForumType.value = controller.forumsType[0];
          if (controller.forumsList.isEmpty) {
            controller.loadForums();
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
                        controller.forumsList.isEmpty))
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("No Forum Found",
                              style: AppTextStyles.textStyleBoldBodyMedium),
                          InkWell(
                            onTap: () {
                              controller.loadForums(showAlert: true);
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
                          myAppBar(goBack: false, title: 'Forums', actions: [
                            MyAnimSearchBar(
                                rtl: true,
                                width: MediaQuery.of(context).size.width,
                                textController: controller.searchController,
                                closeSearchOnSuffixTap: true,
                                onSuffixTap: () {
                                  controller.searchController.clear();
                                }),
                          ]),
                          MyDropDown(
                            suffixIconColor: AppColor.green,
                            borderColor: Colors.transparent,
                            textColor: AppColor.green,
                            labelText: 'Forum type',
                            hintText: 'Select',
                            value: controller.selectedForumType.value,
                            fillColor: AppColor.alphaGrey,
                            items: controller.forumsType,
                            onChange: (value) {
                              controller.selectedForumType.value = value;
                              controller.loadForums(showAlert: true);
                            },
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: NotificationListener(
                                onNotification: controller.onScrollNotification,
                                child: RefreshIndicator(
                                  onRefresh: controller.refreshList,
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount:
                                        controller.filteredItemList.length,
                                    itemBuilder: (context, index) {
                                      return forumInfoWidget(
                                          forum: controller
                                              .filteredItemList[index]!);
                                    },
                                  ),
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

  void _showBottomSheet(BuildContext context) {
    controller.newThreadTitleController.clear();
    controller.newThreadContentController.clear();
    var _formKey = GlobalKey<FormState>();
    AppBottomSheets.showAppAlertBottomSheet(
        context: context,
        isFull: true,
        title: "Add New Thread",
        isDismissable: false,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                vSpace,
                MyTextField(
                  controller: controller.newThreadTitleController,
                  hintText: "Title",
                  contentPadding: 20,
                  focusBorderColor: AppColor.primaryBlueDarkColor,
                  textColor: AppColor.blackColor,
                  hintColor: AppColor.blackColor,
                  fillColor: AppColor.alphaGrey,
                  validator: (String? value) {
                    if ((value ?? '').isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                vSpace,
                MyTextField(
                  controller: controller.newThreadContentController,
                  hintText: "Content",
                  minLines: 3,
                  maxLines: 6,
                  contentPadding: 20,
                  focusBorderColor: AppColor.primaryBlueDarkColor,
                  textColor: AppColor.blackColor,
                  hintColor: AppColor.blackColor,
                  fillColor: AppColor.alphaGrey,
                  validator: (String? value) {
                    if ((value ?? '').isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                vSpace,
                vSpace,
                Button(
                  buttonText: 'Submit',
                  textColor: AppColor.whiteColor,
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      Get.back();
                      controller.postNewThread(
                        onComplete: () {
                          AppPopUps.showDialogContent(
                              title: 'Success',
                              description: 'New thread created success',
                              // onOkPress: () {
                              //   Get.back();
                              // },
                              // onCancelPress: () {
                              //   Get.back();
                              // },
                              dialogType: DialogType.SUCCES);
                        },
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}
