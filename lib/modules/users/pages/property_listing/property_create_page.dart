import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/app_constants.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/property_create_controller.dart';
import 'package:zeerac_flutter/modules/users/pages/property_listing/property_create_views.dart';
import 'package:zeerac_flutter/modules/users/pages/property_listing/property_listing_widgets.dart';
import 'package:zeerac_flutter/utils/app_pop_ups.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import '../../../../common/common_widgets.dart';
import '../../../../common/loading_widget.dart';

class PropertyCreatePage extends GetView<PropertyCreateController>
    with PropertyListingWidgets {
  PropertyCreatePage({Key? key}) : super(key: key);
  static const id = '/PropertyCreatePage';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return controller.goBackWard();
      },
      child: Scaffold(
        appBar: myAppBar(goBack: true, title: 'Create Property', actions: [
          InkWell(
            onTap: () {
              AppPopUps.showDialog(
                description: 'Are you sure to cancel?',
                onOkPress: () {
                  return Get.back();
                },
              );
            },
            child: const Flexible(
              child: Icon(
                Entypo.cancel,
              ),
            ),
          ),
        ]),
        body: GetX<PropertyCreateController>(
          initState: (state) {},
          builder: (_) {
            return SafeArea(
              child: Stack(
                children: [
                  getCurrentView(),
                  if (controller.isLoading.isTrue) LoadingWidget(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  getCurrentView() {
    return controller.viewsList[controller.currentViewIndex.value];
  }
}
