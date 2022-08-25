import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/controllers/social_feed_controller.dart';
import 'package:zeerac_flutter/modules/users/models/social_posts_response_model.dart';
import 'package:zeerac_flutter/modules/users/pages/social_feed/social_feed_widget_mixin.dart';
import '../../../../common/common_widgets.dart';
import '../../../../common/loading_widget.dart';

class AllCommentsView extends GetView<SocialFeedController>
    with SocialFeedWidgetMixin {
  AllCommentsView({Key? key, required this.postModel}) : super(key: key) {
    controller.addNewCommentTextController.clear();
    // commentsList.add(Comments(content: 'new test'));
  }

  late Rx<SocialPostModel> postModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SocialFeedController>(
        id: 'comments',
        builder: (logic) {
          return Column(
            children: [
              vSpace,
              Expanded(
                child: ListView.builder(
                    itemCount: postModel.value.comments.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return commentCommenterView(
                          comment: postModel.value.comments.elementAt(index));
                    }),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 20.h, top: 20.h),
                color: AppColor.whiteColor,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          ///add images
                        },
                        child: const SvgViewer(
                          height: 30,
                          width: 30,
                          svgPath: "assets/icons/ic_add.svg",
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: TextField(
                        controller: controller.addNewCommentTextController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Enter your comment',
                          hintStyle: AppTextStyles.textStyleNormalBodyXSmall,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          contentPadding: const EdgeInsets.all(16),
                          fillColor: AppColor.alphaGrey,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print('on tap');
                        postModel.value.comments
                            .add(Comments(content: 'new content'));
                        controller.update(['comments', 'feed']);
//                        controller.addNewComment();
                      },
                      child: const Expanded(
                        child: SvgViewer(
                          height: 20,
                          width: 20,
                          svgPath: "assets/icons/ic_send_message.svg",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
