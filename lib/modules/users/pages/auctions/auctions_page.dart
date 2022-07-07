import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/controllers/auctions_listing_controller.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import 'package:zeerac_flutter/utils/myAnimSearchBar.dart';
import '../../../../common/loading_widget.dart';
import 'auctions_widgets.dart';

class AuctionsListingPage extends GetView<AuctionsListingController>
    with AuctionWidgetMixin {
  const AuctionsListingPage({Key? key}) : super(key: key);
  static const id = '/AuctionsListingPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // controller.addNewAuction()
..
        },
        child: const Icon(Icons.add, color: AppColor.whiteColor),
      ),
      body: GetX<AuctionsListingController>(
        initState: (state) {
          if (controller.auctionsFileList.isEmpty) {
            controller.loadAuctionsFile();
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
                        controller.auctionsFileList.isEmpty))
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("No Project Found",
                              style: AppTextStyles.textStyleBoldBodyMedium),
                          InkWell(
                            onTap: () {
                              controller.loadAuctionsFile(showAlert: true);
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
                          myAppBar(goBack: false, title: 'Auctions', actions: [
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
                                    return auctionWidget(
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
