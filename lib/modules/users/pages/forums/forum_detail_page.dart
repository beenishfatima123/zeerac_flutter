import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/modules/users/controllers/forum_detail_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import 'package:zeerac_flutter/modules/users/models/forums_response_model.dart';
import '../../../../common/loading_widget.dart';

class ForumDetailPage extends GetView<ForumDetailController> {
  ForumDetailPage({Key? key}) : super(key: key);
  static const id = '/ForumDetailPage';

  ForumModel? forumModel = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<ForumDetailController>(
        initState: (state) {
          if (forumModel != null) {
            controller.initController(forumModel: forumModel!);
          }
        },
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                if (forumModel != null) Text("Forum Detail Page...."),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
