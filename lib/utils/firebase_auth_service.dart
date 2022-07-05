import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:zeerac_flutter/my_application.dart';
import 'package:zeerac_flutter/utils/app_pop_ups.dart';
import 'package:zeerac_flutter/utils/firebase_paths.dart';
import 'package:zeerac_flutter/utils/helpers.dart';

import '../modules/users/models/firebase_user_model.dart';

class FirebaseAuthService {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static Future<bool> signInWithEmailAndPassword(
      String email, String password) async {
    await auth.signOut();
    printWrapped("..........signing in with firebase........");
    printWrapped(email);
    printWrapped(password);
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      return Future.value(user.user != null);
    } catch (e) {
      printWrapped("..........signing in with firebase failed........");

      AppPopUps.showSnackBar(message: e.toString(), context: myContext!);
      return Future.value(false);
    }
  }

  static Future<bool> createAuthUserFirebase(
      {required FirebaseUserModel userModel}) async {
    try {
      printWrapped("......creating firebase user.....");
      printWrapped(userModel.emailForFirebase ?? '---');
      printWrapped(userModel.password ?? '---');
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: userModel.emailForFirebase!, password: userModel.password!);
      return Future.value(userCredential.user != null);
    } catch (e) {
      printWrapped("......creating firebase user failed.....");
      AppPopUps.showSnackBar(message: e.toString(), context: myContext!);
      return Future.value(false);
    }
  }

  static Future<void> createFireStoreUserEntry(
      {required FirebaseUserModel userModel}) async {
    try {
      printWrapped("..........creating entry firebase........");

      return await FirebaseFirestore.instance
          .collection(FirebasePathNodes.users)
          .doc(userModel.uid)
          .set(userModel.toMap(), SetOptions(merge: true));
    } catch (e) {
      printWrapped("..........creating entry firebase failed........");

      AppPopUps.showSnackBar(message: e.toString(), context: myContext!);
      return Future.value();
    }
  }

  static Future<bool> checkIfUserExistsInDb({required String userId}) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(FirebasePathNodes.users)
          .doc(userId)
          .get();
      return Future.value(snapshot.exists);
    } catch (e) {
      AppPopUps.showSnackBar(message: e.toString(), context: myContext!);
      return Future.value(false);
    }
  }
}
