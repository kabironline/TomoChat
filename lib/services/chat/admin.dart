import 'package:cloud_firestore/cloud_firestore.dart';

//Adds admin to channel
Future addAdminToChannel(String userId, String channelId) {
  return FirebaseFirestore.instance
      .collection('channels')
      .doc(channelId)
      .update({
    'admins': FieldValue.arrayUnion([userId])
  });
}

//Removes admin from channel
Future removeAdminFromChannel(String userId, String channelId) {
  return FirebaseFirestore.instance
      .collection('channels')
      .doc(channelId)
      .update({
    'admins': FieldValue.arrayRemove([userId])
  });
}