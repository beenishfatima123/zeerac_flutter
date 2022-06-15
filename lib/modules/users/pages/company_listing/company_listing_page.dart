import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import '../../../../common/loading_widget.dart';
import '../../controllers/company_listing_controller.dart';

class CompanyListingPage extends GetView<CompanyListingController> {
  const CompanyListingPage({Key? key}) : super(key: key);
  static const id = '/CompanyListingPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<CompanyListingController>(
        initState: (state) {},
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                Text("companies"),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
