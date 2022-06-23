import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/terms_and_condtions_controller.dart';
import '../../../../common/loading_widget.dart';

class TermsAndConditionsPage extends GetView<TermsAndConditionsController> {
  const TermsAndConditionsPage({Key? key}) : super(key: key);
  static const id = '/TermsAndConditionsPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<TermsAndConditionsController>(
        initState: (state) {},
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                Text("Terms and conditions",
                    style: AppTextStyles.textStyleBoldTitleLarge),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
