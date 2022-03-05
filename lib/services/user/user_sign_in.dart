import 'package:TomoChat/modals/user_modals.dart';
import 'package:TomoChat/services/get_modals.dart';
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
  await prefs.setStringList('user', [
    user.name,
    user.uid,
    user.image,
    user.phoneNumber ?? "",
    user.email ?? "",
    user.createdAt.toIso8601String()
  ]);
  return user;
}

Future<UserModel?> signInWithUID(String uid) async {
  var userData =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
  if (!userData.exists) {
    return null;
  }
  var user = UserModel.fromDocument(userData);
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('user', [
    user.name,
    user.uid,
    user.image,
    user.phoneNumber ?? "",
    user.email ?? "",
    user.createdAt.toIso8601String()
  ]);
  return user;
}


/// Checks whether the user has signed in or not!
/// It returns true if the user is signed in, false otherwise.
Future<bool> checkIfUserSignedIn() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('user') != null;      
}

/// Returns the signed in user! It loads the user from the shared preferences.
Future<UserModel> getSignedInUser() async {
  var prefs = await SharedPreferences.getInstance();
  return getUserModel(prefs.getStringList('user'));
}