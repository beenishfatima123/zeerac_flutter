import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import 'package:zeerac_flutter/modules/users/pages/home/search_filter_listing_page.dart';
import 'package:zeerac_flutter/utils/app_alert_bottom_sheet.dart';
import 'package:zeerac_flutter/utils/extension.dart';
import '../../../../common/loading_widget.dart';
import '../../../../common/spaces_boxes.dart';

class HomePage extends GetView<HomeController> {
  HomePage({Key? key}) : super(key: key);
  static const id = '/HomePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<HomeController>(
        initState: (state) {},
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                animatedBackGround(),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColor.primaryBlueDarkColor.withAlpha(170),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              'Buy anywhere,Sell anywhere',
                              textStyle: AppTextStyles.textStyleBoldTitleLarge
                                  .copyWith(color: AppColor.whiteColor),
                              speed: const Duration(milliseconds: 200),
                            ),
                          ],
                          totalRepeatCount: 4,
                          repeatForever: true,
                          pause: const Duration(milliseconds: 100),
                          displayFullTextOnTap: true,
                          stopPauseOnTap: true,
                        ),
                        vSpace,
                        /*   Row(
                          children: [
                            FlutterSwitch(
                              width: 100.0,
                              height: 40.0,
                              valueFontSize: 20.0,
                              toggleSize: 30.0,
                              value: controller.isBuying.value,
                              borderRadius: 30.0,
                              padding: 8.0,
                              activeText: 'Buy',
                              activeColor: AppColor.green,
                              inactiveColor: AppColor.greyColor,
                              inactiveText: 'Rent',
                              showOnOff: true,
                              onToggle: (val) {
                                controller.isBuying.value = val;
                              },
                            ),
                          ],
                        ),*/
                        vSpace,
                        vSpace,
                        InkWell(
                          onTap: () {
                            Get.toNamed(SearchFilterListingPage.id);
                          },
                          child: MyTextField(
                            controller: TextEditingController(),
                            hintText: "Search for listing",
                            leftPadding: 0,
                            rightPadding: 0,
                            enable: false,
                            contentPadding: 20,
                            suffixIcon: "assets/icons/ic_search.svg",
                            focusBorderColor: AppColor.primaryBlueDarkColor,
                            textColor: AppColor.blackColor,
                            hintColor: AppColor.blackColor,
                            fillColor: AppColor.alphaGrey,
                          ),
                        ),
                        vSpace,
                        Button(
                          buttonText: 'Submit new listing',
                          textColor: AppColor.blackColor,
                          textStyle: AppTextStyles.textStyleNormalBodyMedium,
                          color: AppColor.whiteColor,
                          onTap: () {},
                        ),
                        vSpace,
                        vSpace,
                        vSpace,
                      ],
                    ),
                  ),
                ),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  animatedBackGround() {
    return controller.motionController != null
        ? AnimatedBuilder(
            animation: controller.motionController!,
            builder: (context, child) {
              controller.scale = 1 + controller.motionController!.value;
              return Transform.scale(
                scale: controller.scale,
                child: Container(
                  // height: DynamicSize.height(0.80, context),
                  decoration: const BoxDecoration(
                    color: AppColor.whiteColor,
                    image: DecorationImage(
                      image: AssetImage('assets/images/property_mgmt.jpeg'),
                      opacity: 0.8,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            })
        : const IgnorePointer();
  }

  void showBottom(BuildContext context) {
    AppBottomSheets.showAppAlertBottomSheet(
        context: context,
        isFull: true,
        title: "Apply Filters",
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              vSpace,
              MyTextField(
                hintText: "City",
                unfocusBorderColor: AppColor.primaryBlueColor,
                focusBorderColor: AppColor.primaryBlueDarkColor,
                leftPadding: 0,
                rightPadding: 0,
              ),
            ],
          ),
        ));
  }
}
