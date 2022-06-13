import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/property_detail_controller.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart'
    as propertyModel;
import '../../../../common/loading_widget.dart';

class PropertyDetailsPage extends GetView<PropertyDetailController> {
  PropertyDetailsPage({Key? key}) : super(key: key);
  static const id = '/PropertyDetailsPage';

  propertyModel.Results? property = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<PropertyDetailController>(
        initState: (state) {},
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        expandedHeight: 200.0,
                        floating: false,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                            centerTitle: true,
                            title: Text(
                              property?.name ?? '',
                              style: AppTextStyles.textStyleBoldBodyMedium
                                  .copyWith(color: AppColor.whiteColor),
                            ),
                            background: Image.network(
                              "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                              fit: BoxFit.cover,
                            )),
                      ),
                    ];
                  },
                  body: Center(
                    child: Text("Sample Text"),
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
