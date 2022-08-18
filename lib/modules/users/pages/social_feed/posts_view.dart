import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/modules/users/pages/social_feed/social_feed_widget_mixin.dart';
import '../../../../common/loading_widget.dart';
import '../../../../common/spaces_boxes.dart';
import '../../controllers/social_feed_controller.dart';

class PostsView extends GetView<SocialFeedController>
    with SocialFeedWidgetMixin {
  const PostsView({Key? key}) : super(key: key);
  static const id = '/PostsView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ///search bar
            Row(
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
            ),
            vSpace,
            Expanded(
                child: ListView.builder(
                    itemCount: 10,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return makeFeed(
                          userName: 'Aiony Haust',
                          userImage: 'assets/icons/ellipseperson.png',
                          feedTime: '1 hr ago',
                          feedText:
                              'All the Lorem Ipsum generators on the Internet tend to repeat predefined.',
                          feedImage: 'assets/images/hunza.png');
                    }))
          ],
        ),
      ),
    );
  }
}
