import 'package:TomoChat/constants.dart';
import 'package:TomoChat/modals/user_modals.dart';
import 'package:TomoChat/services/user/set_userdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future registerUser(String name, String? email, String phoneNumber, String uid,
    String? description, String? imageURL) async {
  var userCreatedAt = DateTime.now();
  var _image = imageURL ?? kdefualtUserProfilePicture;
  await FirebaseFirestore.instance.collection('users').doc(uid).set({
    'displayName': name,
    'email': email,
    'phoneNumber': phoneNumber,
    'createdAt': userCreatedAt,
    'uid': uid,
    'displayPicture': _image,
    'description': description ?? 'I am new to TomoChat!',
  });
  await setLocalUser([
    name,
    uid,
    _image,
    phoneNumber,
    email ?? "",
    userCreatedAt.toIso8601String(),
    description ?? 'I am new to TomoChat!'
  ]);
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
