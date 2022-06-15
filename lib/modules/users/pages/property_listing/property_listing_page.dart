import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/property_listing_page_controller.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart';
import 'package:zeerac_flutter/modules/users/pages/property_listing/property_listing_widgets.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import '../../../../common/loading_widget.dart';

class PropertyListingPage extends GetView<PropertyListingPageController> {
  PropertyListingPage({Key? key}) : super(key: key);
  static const id = '/PropertyListingPage';
  final PropertyListingModel? _propertyListingModel = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
          title: '${_propertyListingModel?.count.toString()} Properties'),
      body: GetX<PropertyListingPageController>(
        initState: (state) {
          controller.initialiseValue(_propertyListingModel);
        },
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                if (controller.propertiesListingModel != null)
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: NotificationListener(
                      onNotification: controller.onScrollNotification,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.propertiesList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return propertiesWidget(
                              controller.propertiesList![index]);
                        },
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
}
