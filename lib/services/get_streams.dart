import 'package:cloud_firestore/cloud_firestore.dart';

Stream<QuerySnapshot> getChannelStream(String channelId) {
  return FirebaseFirestore.instance
      .collection('channels')
      .doc(channelId)
      .collection('messages')
      .orderBy('time', descending: false)
      .snapshots();
}

Stream<QuerySnapshot> getRecentMessages(String uid) {
  Stream<QuerySnapshot> snapshots;
  snapshots = FirebaseFirestore.instance
      .collection('recentChat').where('users', arrayContains: uid).snapshots();
  return snapshots;
}
