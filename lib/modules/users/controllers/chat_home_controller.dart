import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../my_application.dart';
import '../../../utils/app_pop_ups.dart';
import '../../../utils/firebase_paths.dart';
import '../../../utils/helpers.dart';

class ChatHomeController extends GetxController {
  var haveChat = false.obs;

  void deleteChat(
      {onComplete, required String userId, required String docId}) async {
    AppPopUps.showProgressDialog(context: myContext!);

    if (userId.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('Messages')
          .doc(userId)
          .update({docId: FieldValue.delete()});

      QuerySnapshot<Map<String, dynamic>> kk = await FirebaseFirestore.instance
          .collection('Messages')
          .doc(userId)
          .collection(docId)
          .get();
      printWrapped("maapppp");
      for (final doc in kk.docs) {
        Map<String, dynamic> map = doc.data();

        printWrapped(map.toString());

        await doc.reference.delete();
      }

      AppPopUps().dissmissDialog();
      //onComplete(false);
      onComplete(true);
    } else {
      onComplete(false);
    }
  }

  void loadTest() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('messages')
        .doc('BJhkOUBINhUj19v5zUIfuCETrGP23BLaQncsWwZTkafcvAGnYLJinMw2')
        .collection('chat')
        .get();

    for (var element in snapshot.docs) {
      printWrapped(element.data().toString());
    }
  }
}
