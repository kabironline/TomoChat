import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> checkUserExists (String uid) async {
  var userExists = false;
  await FirebaseFirestore.instance.collection("users").doc(uid).get().then((doc) {
    if (doc.exists) {
      userExists = true;
    }
  });
  return userExists;
}