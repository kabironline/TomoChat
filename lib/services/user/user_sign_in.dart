import 'package:chat_app/modals/user_modals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<UserModel?> signInWithPhone() async {
  var user = FirebaseAuth.instance.currentUser?.uid;
  var userData = await FirebaseFirestore.instance
      .collection('users')
      .doc(user)
      .get();
  if (!userData.exists) {
    return null;
  }
  return UserModel.fromDocument(userData);
}
