import 'package:cloud_firestore/cloud_firestore.dart';

Stream<QuerySnapshot> getChannelStream(String channelId) {
  return FirebaseFirestore.instance
      .collection('channels')
      .doc(channelId)
      .collection('messages')
      .orderBy('time', descending: true)
      .snapshots();
}

Stream<QuerySnapshot> getRecentMessages(String uid) {
  Stream<QuerySnapshot> snapshots;
  snapshots = FirebaseFirestore.instance
      .collection('recentChat')
      .where('users', arrayContains: uid)
      .orderBy("lastMessageTime", descending: true)
      .snapshots();
  return snapshots;
}
