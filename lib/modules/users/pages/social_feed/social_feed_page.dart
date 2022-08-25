import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/modules/users/pages/social_feed/groups_view.dart';
import 'package:zeerac_flutter/modules/users/pages/social_feed/posts_view.dart';
import '../../../../common/loading_widget.dart';
import '../../controllers/social_feed_controller.dart';

class SocialFeedPage extends GetView<SocialFeedController> {
  const SocialFeedPage({Key? key}) : super(key: key);
  static const id = '/SocialFeedPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          elevation: 20,
          currentIndex: controller.selectedIndex.value,
          onTap: (value) {
            controller.selectedIndex.value = value;
            controller.pageViewController.jumpToPage(value);
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.compost_outlined), label: 'Posts'),
            BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Groups')
          ],
        );
      }),
      body: GetX<SocialFeedController>(
        initState: (state) {
          controller.loadGroups();
          controller.loadPosts();
        },
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                PageView(
                    controller: controller.pageViewController,
                    onPageChanged: (value) {
                      controller.selectedIndex.value = value;
                    },
                    children: [PostsView(), GroupsView()]),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
