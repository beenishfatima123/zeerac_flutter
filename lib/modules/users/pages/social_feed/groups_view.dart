import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/loading_widget.dart';
import '../../controllers/social_feed_controller.dart';

class GroupsView extends GetView<SocialFeedController> {
  const GroupsView({Key? key}) : super(key: key);
  static const id = '/GroupsView';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('GroupView'),
      ),
    );
  }
}
