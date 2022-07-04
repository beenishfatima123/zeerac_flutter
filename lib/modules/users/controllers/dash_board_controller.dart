import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:zeerac_flutter/common/languages.dart';
import 'package:zeerac_flutter/dio_networking/Push_notifications_manager.dart';
import 'package:zeerac_flutter/modules/users/models/firebase_user_model.dart';
import 'package:zeerac_flutter/modules/users/models/notification_model.dart';
import 'package:zeerac_flutter/utils/firebase_paths.dart';

class DashBoardController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  RxBool isLoading = false.obs;

  RxInt selectedIndex = 0.obs;

  var languageName = Languages.getCurrentLanguageName().obs;

  void sendTestNotificationToSelf() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(FirebasePathNodes.users)
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    FirebaseUserModel userModel =
        FirebaseUserModel.fromMap(snapshot.data() as Map<String, dynamic>);
    sendPushNotification(
        toDeviceId: userModel.deviceToken ?? '',
        notificationModel: NotificationModel(
            id: const Uuid().v4(),
            fromId: 'test',
            toId: 'test',
            title: 'hello',
            body: 'test notification',
            time: DateTime.now().millisecondsSinceEpoch.toString(),
            isRead: false));
  }
}
