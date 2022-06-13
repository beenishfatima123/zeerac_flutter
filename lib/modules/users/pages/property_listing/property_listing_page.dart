import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart';
import 'package:zeerac_flutter/modules/users/pages/property_listing/property_listing_widgets.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import '../../../../common/loading_widget.dart';

class PropertyListingPage extends GetView<HomeController> {
  PropertyListingPage({Key? key}) : super(key: key);
  static const id = '/PropertyListingPage';
  final PropertyListingModel? _propertyListingModel = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
          title: '${_propertyListingModel?.count.toString()} Properties'),
      body: GetX<HomeController>(
        initState: (state) {},
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                if (_propertyListingModel != null)
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: ListView.builder(
                      itemCount: _propertyListingModel?.results?.length ?? 0,
                      itemBuilder: (context, index) {
                        return propertiesWidget(
                            _propertyListingModel!.results![index]);
                      },
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
