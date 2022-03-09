import 'package:TomoChat/modals/user_modals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future registerUser(String name, String? email, String phoneNumber, String uid, String? description,
    String? imageURL) async {
  var userCreatedAt = DateTime.now();
  var _image = imageURL ?? 'https://firebasestorage.googleapis.com/v0/b/chat-app-test-84888.appspot.com/o/default%20profile%20picture.jpg?alt=media&token=bbcc2a67-b153-4944-a627-c214b0812834';
  await FirebaseFirestore.instance.collection('users').doc(uid).set({
    'displayName': name,
    'email': email,
    'phoneNumber': phoneNumber,
    'createdAt': userCreatedAt,
    'uid': uid,
    'displayPicture': _image,
    'description': description ?? 'I am new to TomoChat!', 
  });
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('user', [name,uid,_image,phoneNumber,email??"",userCreatedAt.toIso8601String()]);
  return UserModel(
    email: email,
    name: name,
    image: _image,
    createdAt: userCreatedAt,
    uid: uid,
    description: description ?? 'I am new to TomoChat!',
    phoneNumber: phoneNumber,
  );
}
