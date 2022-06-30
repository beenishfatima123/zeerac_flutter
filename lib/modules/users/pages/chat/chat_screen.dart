import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/modules/users/controllers/chat_with_user_controller.dart';
import 'package:zeerac_flutter/utils/app_utils.dart';
import '../../../../common/common_widgets.dart';
import '../../../../common/styles.dart';
import '../../../../utils/firebase_paths.dart';
import '../../../../utils/user_defaults.dart';
import '../../models/chat_model.dart';
import '../../models/chat_user_model.dart';

class ChatScreen extends GetView<ChatWithUserController> {
  static const id = "/ChatScreen";

  ChatScreen({Key? key}) : super(key: key);

  ChatUserModel? otherUserModel = Get.arguments;
  String? currentUserId = UserDefaults.getCurrentUserId();

  @override
  Widget build(BuildContext context) {
    return GetX<ChatWithUserController>(initState: (state) {
      currentUserId = UserDefaults.getCurrentUserId();
    }, builder: (staex) {
      controller.listScrollController = ScrollController();
      controller.temp.value;
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColor.whiteColor,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: AppColor.blackColor),
          title: otherUserModel == null
              ? const IgnorePointer()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        NetworkCircularImage(
                          url: otherUserModel?.otherUserProfileImage ?? '',
                          radius: 20,
                        ),
                        SizedBox(
                          width: 35.w,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(otherUserModel?.otherUserName ?? '',
                                style: AppTextStyles.textStyleBoldBodySmall),
                            /* Text("",
                                    style: AppTextStyles.textStyleBoldBodySmall
                                        .copyWith(
                                            color: AppColor.greenColor,
                                            fontWeight: FontWeight.normal))*/
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        /*   Padding(
                        padding: EdgeInsets.all(50.w),
                        child: const SvgViewer(
                            svgPath: "assets/icons/ic_video_call.svg"),
                      ),*/
                        InkWell(
                          onTap: () {
                            AppUtils.dialNumber(
                                context: context,
                                phoneNumber:
                                    otherUserModel?.otherUserContact ?? '00');
                          },
                          child: Padding(
                            padding: EdgeInsets.all(50.w),
                            child: const SvgViewer(
                                svgPath: "assets/icons/ic_audio_call.svg"),
                          ),
                        )
                      ],
                    )
                  ],
                ),
        ),
        backgroundColor: AppColor.alphaGrey,
        body: (otherUserModel == null)
            ? Center(
                child: Text(
                  "Something went Wrong",
                  style: AppTextStyles.textStyleBoldBodyMedium,
                ),
              )
            : SafeArea(
                child: Column(
                children: [
                  Expanded(
                    child: Container(
                      //  height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.only(
                        left: 50.w,
                        right: 50.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.alphaGrey,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.r),
                            topRight: Radius.circular(40.r)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection(FirebasePathNodes.messages)
                              .doc(currentUserId)
                              .collection(otherUserModel?.otherUserId ?? '')
                              .orderBy('timeStamp', descending: true)
                              .limit(controller.limit.value)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text("Loading");
                            }
                            return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                shrinkWrap: true,
                                controller: controller.listScrollController,
                                physics: const BouncingScrollPhysics(),
                                reverse: true,
                                itemBuilder: (contxt, index) {
                                  Map<String, dynamic> data =
                                      snapshot.data!.docs[index].data()!
                                          as Map<String, dynamic>;
                                  ChatModel chatModel = ChatModel.fromMap(data);
                                  if (chatModel.type == 0) {
                                    return textType(chatModel, context);
                                  } else if (chatModel.type == 1) {
                                    //image
                                    return _loadImage(chatModel, context);
                                  } else {
                                    //file
                                    return InkWell(
                                      onTap: () {
                                        controller.launchUrl(chatModel);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            chatModel.fromId == currentUserId
                                                ? MainAxisAlignment.end
                                                : MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 500.w,
                                            height: 60.h,
                                            decoration: BoxDecoration(
                                                color: AppColor.blackColor
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            margin: const EdgeInsets.all(10),
                                            child: Center(
                                              child: Text('File',
                                                  style: AppTextStyles
                                                      .textStyleBoldBodyMedium),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                });
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 20.h, top: 20.h),
                    color: AppColor.whiteColor,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              controller.pickFileAndSendMessage(
                                  fromUserId: currentUserId ?? '',
                                  otherUserMobile:
                                      otherUserModel?.otherUserContact ?? "",
                                  otherUserImage:
                                      otherUserModel?.otherUserProfileImage ??
                                          "",
                                  otherUserName:
                                      otherUserModel?.otherUserName ?? "",
                                  toId: otherUserModel?.otherUserId ?? "");
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
                            controller: controller.chatSendTextController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            minLines: 1,
                            decoration: InputDecoration(
                              hintText: 'Enter your message',
                              hintStyle:
                                  AppTextStyles.textStyleNormalBodyXSmall,
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
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              sendMessage();
                            },
                            child: const SvgViewer(
                              height: 30,
                              width: 30,
                              svgPath: "assets/icons/ic_send_message.svg",
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
      );
    });
  }

  Widget getChatBubble(BubbleType bubbleType, String message, context) {
    if (bubbleType == BubbleType.sendBubble) {
      return ChatBubble(
        clipper: ChatBubbleClipper3(type: bubbleType),
        alignment: Alignment.topRight,
        margin: const EdgeInsets.only(top: 20),
        backGroundColor: AppColor.chatSendColor.withOpacity(0.34),
        shadowColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Text(
            message,
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
    } else {
      return ChatBubble(
        clipper: ChatBubbleClipper3(type: BubbleType.receiverBubble),
        backGroundColor: AppColor.chatReceiveColor.withOpacity(0.34),
        margin: const EdgeInsets.only(top: 20),
        shadowColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Text(
            message,
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
    }
  }

  void sendMessage() {
    if (controller.chatSendTextController.text.isNotEmpty) {
      controller.sendMessage(
          otherUserPhone: otherUserModel?.otherUserContact ?? '',
          otherUserName: otherUserModel?.otherUserName ?? '',
          otherUserImage: otherUserModel?.otherUserProfileImage ?? '',
          mode: ChatModel(
              message: controller.chatSendTextController.text,
              fromId: currentUserId ?? "",
              toId: otherUserModel?.otherUserId ?? '',
              timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
              //var dt = DateTime.fromMillisecondsSinceEpoch(millis);
              type: 0));

      /* view.listOfChat.add(ChatModel(view.chatSendTextController.text, true));
      view.chatSendTextController.clear();
      setState(() {});*/
    }
  }

  Widget textType(ChatModel chatModel, context) {
    if (chatModel.fromId == currentUserId) {
      return getChatBubble(BubbleType.sendBubble, chatModel.message, context);
    } else {
      return getChatBubble(
          BubbleType.receiverBubble, chatModel.message, context);
    }
  }

  Widget _loadImage(ChatModel chatModel, BuildContext context) {
    return Row(
      mainAxisAlignment: chatModel.fromId == currentUserId
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Container(
          color: AppColor.alphaGrey,
          margin: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width * 0.5,
          height: 300.h,
          child: CachedNetworkImage(
            imageUrl: chatModel.message,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image:
                    DecorationImage(image: imageProvider, fit: BoxFit.fitWidth),
              ),
            ),
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                Center(child: Icon(Icons.error)),
          ),
        ),
      ],
    );
  }
}
