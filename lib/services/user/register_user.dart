import 'package:chat_app/modals/user_modals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localstore/localstore.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future registerUser(String name, String? email, String phoneNumber, String uid,
    String imageURL) async {
  var userCreatedAt = DateTime.now();
  await FirebaseFirestore.instance.collection('users').doc(uid).set({
    'displayName': name,
    'email': email,
    'phoneNumber': phoneNumber,
    'createdAt': userCreatedAt,
    'uid': uid,
    'displayPicture': imageURL
  });
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('user', [name,uid,imageURL,phoneNumber,email??"",userCreatedAt.toIso8601String()]);
  return UserModel(
      email: email,
      name: name,
      image: imageURL,
      createdAt: userCreatedAt,
      uid: uid,
      phoneNumber: phoneNumber);
}
