import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/modules/users/models/social_posts_response_model.dart';
import 'package:zeerac_flutter/modules/users/pages/social_feed/social_feed_widget_mixin.dart';
import 'package:zeerac_flutter/modules/users/pages/social_feed/widgets/post_feed_widget.dart';
import '../../../../common/loading_widget.dart';
import '../../../../common/spaces_boxes.dart';
import '../../../../common/styles.dart';
import '../../controllers/social_feed_controller.dart';

class PostsView extends GetView<SocialFeedController>
    with SocialFeedWidgetMixin {
  PostsView({Key? key}) : super(key: key);
  static const id = '/PostsView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ///search bar
              controller.socialPostFilteredItemList.isNotEmpty
                  ? Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.grey[200]),
                            child: const TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey),
                                hintText: "Search",
                              ),
                            ),
                          ),
                        ),
                        hSpace,
                        Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                          size: 30,
                        )
                      ],
                    )
                  : Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(20),
                      child: InkWell(
                        onTap: () {
                          controller.loadPosts(showAlert: true);
                        },
                        child: Center(
                          child: Text(
                            'no result found refresh?',
                            style: AppTextStyles.textStyleBoldSubTitleLarge,
                          ),
                        ),
                      ),
                    ),
              vSpace,

              Expanded(
                child: RefreshIndicator(
                  onRefresh: () {
                    controller.refreshPostList();
                    return Future.delayed(const Duration(seconds: 2));
                  },
                  child: ListView.builder(
                    itemCount: controller.socialPostFilteredItemList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return PostFeedWidget(
                          postModel: controller.socialPostFilteredItemList
                              .elementAt(index)!);
                    },
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
