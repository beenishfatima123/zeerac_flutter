import 'package:get/get.dart';
import 'package:zeerac_flutter/modules/users/models/forums_response_model.dart';

class ForumDetailController extends GetxController {
  RxBool isLoading = false.obs;
  late ForumModel forumModel;
  void initController({required ForumModel forumModel}) {
    this.forumModel = forumModel;
  }
}
