import 'package:chat_app/modals/user_modals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<UserModel?> signInWithPhone() async {
  var userId = FirebaseAuth.instance.currentUser?.uid;
  var userData =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  if (!userData.exists) {
    return null;
  }
  var user = UserModel.fromDocument(userData);
  final prefs = await SharedPreferences.getInstance();
  var userLocal = await prefs.setStringList('user', [
    user.name,
    user.uid,
    user.image,
    user.phoneNumber ?? "",
    user.email ?? "",
    user.createdAt.toIso8601String()
  ]);
  print(userLocal);
  return user;
}
