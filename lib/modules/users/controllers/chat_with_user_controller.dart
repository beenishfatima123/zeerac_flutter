import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeerac_flutter/modules/users/models/user_model.dart';
import '../../../my_application.dart';
import '../../../utils/app_pop_ups.dart';
import '../../../utils/helpers.dart';
import '../../../utils/user_defaults.dart';
import '../models/chat_model.dart';
import '../models/last_firebase_message_model.dart';

class ChatWithUserController extends GetxController {
  List<ChatModel> listOfChat = [];
  var temp = 0.obs;

  var limit = 100.obs;

  UserModel? currentUser;

  @override
  void onInit() {
    currentUser = UserDefaults.getUserSession();
    super.onInit();
  }

  ScrollController? listScrollController;

  TextEditingController chatSendTextController = TextEditingController();

  void launchUrl(ChatModel chatModel) {
    _launchURL(chatModel.message);
  }

  void _launchURL(_url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  void sendMessage(
      {required ChatModel model,
      required String otherUserName,
      required String otherUserPhone,
      required String otherUserImage}) async {
    LastFirebaseMessageModel otherFirebaseUser = LastFirebaseMessageModel(
        mobile: otherUserPhone,
        name: otherUserName,
        image: otherUserImage,
        time: model.timeStamp,
        id: model.toId,
        lastMessage: model.message);

    ///current user information
    LastFirebaseMessageModel? currentFireBaseUser = LastFirebaseMessageModel(
        mobile: currentUser?.phoneNumber ?? '',
        name: currentUser?.firstName ?? '',
        image: currentUser?.photo ?? '',
        time: model.timeStamp,
        id: model.fromId,
        lastMessage: model.message);

    if (model.message.startsWith('http')) {
      currentFireBaseUser.lastMessage = 'file';
      otherFirebaseUser.lastMessage = 'file';
    }

    FirebaseFirestore.instance
        .collection('Messages')
        .doc(model.fromId)
        .set({model.toId: otherFirebaseUser.toMap()}, SetOptions(merge: true));

    FirebaseFirestore.instance.collection('Messages').doc(model.toId).set(
        {model.fromId: currentFireBaseUser.toMap()}, SetOptions(merge: true));

    ////transactionss
    var fromUserMessage = FirebaseFirestore.instance
        .collection('Messages')
        .doc(model.fromId)
        .collection(model.toId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    var toUserMessage = FirebaseFirestore.instance
        .collection('Messages')
        .doc(model.toId)
        .collection(model.fromId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        fromUserMessage,
        model.toMap(),
      );

      transaction.set(
        toUserMessage,
        model.toMap(),
      );
    });
    listScrollController?.animateTo(0.0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    chatSendTextController.clear();
  }

  Future<void> pickFileAndSendMessage(
      {required String fromUserId,
      required String toId,
      required String otherUserName,
      required String otherUserMobile,
      required String otherUserImage}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'pdf', 'doc'],
        allowMultiple: false);
    if (result != null) {
      AppPopUps.showProgressDialog(context: myContext!);
      printWrapped(result.files.single.bytes.toString());
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;
      String extension = result.files.single.extension ?? "";
      printWrapped(extension);
      int type = -1;

      if ((extension) == 'jpg' || (extension) == 'png') {
        type = 1;
      }
      if ((extension) == 'pdf' || (extension) == 'doc') {
        type = 2;
      }
      String url = await uploadFile(
          file: file,
          path: 'chatImages',
          fileName: fileName,
          extension: extension);
      sendMessage(
          otherUserPhone: otherUserMobile,
          otherUserName: otherUserName,
          otherUserImage: otherUserImage,
          model: ChatModel(
              message: url,
              fromId: fromUserId,
              toId: toId,
              timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
              type: type));
      AppPopUps().dissmissDialog();
    }
  }

  Future<String> uploadFile(
      {required File file,
      required String path,
      required String fileName,
      required String extension}) async {
    Reference ref = FirebaseStorage.instance.ref(path).child("/$fileName");
    await ref.putFile(file);
    String url = await ref.getDownloadURL();
    return Future.value(url);
  }
}
