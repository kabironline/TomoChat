import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadImage(File image, String fileName) async {
  var ref = FirebaseStorage.instance.ref().child(fileName);
  var uploadTask = ref.putFile(image);
  var task = await uploadTask.whenComplete(() {});
  return await task.ref.getDownloadURL();
}

Future updateGroupImage(File? image, String uid) async {
  if (image == null) {
    await FirebaseFirestore.instance.collection('channel').doc(uid).update({
      'profile':
          "https://firebasestorage.googleapis.com/v0/b/chat-app-test-84888.appspot.com/o/group_default_image.png?alt=media&token=f3f0180b-6f51-424a-9d5d-be7e8cfe3ff4"
    });
    return;
  }
  var url = await uploadImage(image, 'group/$uid/profile');
  await FirebaseFirestore.instance
      .collection('channel')
      .doc(uid)
      .update({'profile': url});
}
