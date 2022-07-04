import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/utils/firebase_paths.dart';
import '../../../../common/common_widgets.dart';
import '../../../../common/styles.dart';
import '../../../../utils/app_utils.dart';
import '../../../../utils/helpers.dart';
import '../../../../utils/myAnimSearchBar.dart';
import '../../../../utils/user_defaults.dart';
import '../../controllers/chat_home_controller.dart';
import '../../models/chat_user_model.dart';
import 'chat_screen.dart';

class ChatAllHomePage extends GetView<ChatHomeController> {
  ChatAllHomePage({Key? key}) : super(key: key);
  static const id = '/ChatAllHomePage';
  String? currentUserId = UserDefaults.getCurrentUserId();

  @override
  Widget build(BuildContext context) {
    return GetX<ChatHomeController>(initState: (state) {
      currentUserId = UserDefaults.getCurrentUserId();
    }, builder: (stateCtx) {
      //temp
      controller.haveChat.value;

      return Scaffold(
        appBar: myAppBar(goBack: true, title: "Your Chats", actions: [
          MyAnimSearchBar(
            width: MediaQuery.of(context).size.width,
            onSuffixTap: () {},
            closeSearchOnSuffixTap: true,
            textController: TextEditingController(),
          ),
        ]),
        body: currentUserId == null
            ? const Center(
                child: Text('Something went wrong'),
              )
            : SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 20.w,
                          right: 20.w,
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
                                .doc(currentUserId!)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Center(
                                    child: Text('Something went wrong'));
                              }
                              if (snapshot.data?.data() == null) {
                                return const Center(
                                    child: Text('No Chat Found'));
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(child: Text("Loading"));
                              }
                              Map<String, dynamic> mMap =
                                  snapshot.data!.data() as Map<String, dynamic>;

                              // e.value['name']
                              return ListView(
                                  children: mMap.entries
                                      .toList()
                                      .reversed
                                      .map((e) => Dismissible(
                                            direction:
                                                DismissDirection.startToEnd,
                                            confirmDismiss: (DismissDirection
                                                direction) async {
                                              return await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title:
                                                        const Text("Confirm"),
                                                    content: const Text(
                                                        "Are you sure you wish to delete this item?"),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        onPressed: () {
                                                          controller.deleteChat(
                                                              userId:
                                                                  currentUserId ??
                                                                      '',
                                                              docId:
                                                                  e.value['id'],
                                                              onComplete:
                                                                  (status) {
                                                                return Navigator.of(
                                                                        context)
                                                                    .pop(
                                                                        status);
                                                              });
                                                        },
                                                        child: const Text(
                                                            "DELETE"),
                                                      ),
                                                      FlatButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false),
                                                        child: const Text(
                                                            "CANCEL"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            background: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 28.0),
                                              alignment: AlignmentDirectional
                                                  .centerStart,
                                              color: Colors.red,
                                              child: const Icon(
                                                Icons.delete_forever,
                                                color: Colors.white,
                                              ),
                                            ),
                                            resizeDuration: const Duration(
                                                milliseconds: 200),
                                            key: UniqueKey(),
                                            child: InkWell(
                                              onTap: () {
                                                Get.toNamed(
                                                  ChatScreen.id,
                                                  arguments: ChatUserModel(
                                                    otherUserId: e.value['id'],
                                                    otherUserName:
                                                        e.value['name'],
                                                    otherUserContact:
                                                        e.value['mobile'],
                                                    otherUserProfileImage:
                                                        e.value['image'],
                                                  ),
                                                );
                                              },
                                              child: Card(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ListTile(
                                                    title:
                                                        Text(e.value['name']),
                                                    trailing: Text(
                                                      AppUtils.readTimestamp(
                                                        int.parse(
                                                          e.value['time'],
                                                        ),
                                                      ),
                                                    ),
                                                    subtitle: Text(
                                                        e.value['lastMessage']),
                                                    leading:
                                                        NetworkCircularImage(
                                                      radius: 20,
                                                      url: e.value['image'],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ))
                                      .toList());
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      );
    });
  }

  Widget getUsersOfChatRow() {
    return InkWell(
      onTap: () {
        Get.toNamed(ChatScreen.id);
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage:
                const AssetImage('assets/images/place_your_image.png'),
            radius: 180.r,
          ),
          title: Text(
            'User Name',
            style: AppTextStyles.textStyleBoldBodyMedium,
          ),
          subtitle: Text(
            'Hello last message',
            style: AppTextStyles.textStyleNormalBodyXSmall,
          ),
          trailing: Text(
            '09:00 am',
            style: AppTextStyles.textStyleNormalBodyMedium,
          ),
        ),
      ),
    );
  }
}
