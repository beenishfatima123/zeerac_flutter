import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class FirebaseAuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User> handleSignInEmail(String email, String password) async {
    UserCredential result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    final User user = result.user!;

    return user;
  }

  Future<User> handleSignUp(
      String email, String password, String userName) async {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final User user = result.user!;
    await createFirebaseUserInFireStore({
      'createdAt': DateTime.now().toString(),
      'emailForFirebase': email,
      'isOnline': true,
      'uid': user.uid,
      'username': userName
    });

    return user;
  }

  Future<void> createFirebaseUserInFireStore(
      Map<String, dynamic> userMap) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userMap['uid'])
        .set(userMap);
  }

  Future<Map<String, dynamic>?> getFirebaseUserMapFireStore(String id) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  }
}
