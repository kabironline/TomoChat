import 'package:chat_app/modals/user_modals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localstore/localstore.dart';

Future registerUser(String name, String? email, String phoneNumber, String uid,
    String? imageURL) async {
  var userCreatedAt = DateTime.now();
  await FirebaseFirestore.instance.collection('users').doc(uid).set({
    'displayName': name,
    'email': email,
    'phoneNumber': phoneNumber,
    'createdAt': userCreatedAt,
    'uid': uid,
    'displayPicture': imageURL ?? ""
  });
  var local = await Localstore.instance.collection('user').doc(uid).set({
    'displayName': name,
    'email': email,
    'phoneNumber': phoneNumber,
    'createdAt': userCreatedAt,
    'uid': uid,
    'displayPicture': imageURL ?? ""
  });
  print(local);
  return UserModel(
      email: email,
      name: name,
      image: imageURL ?? "",
      date: userCreatedAt,
      uid: uid,
      phoneNumber: phoneNumber);
}
