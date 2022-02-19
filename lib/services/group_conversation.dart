import 'package:cloud_firestore/cloud_firestore.dart';

Future<DocumentSnapshot> getDMChannelFromId(String id) async {
  return await FirebaseFirestore.instance.collection('channels').doc(id).get();
}

Future<String> getOrCreateGroupConversation(List<String> users) async {
  var conversationId = await getGroupConversation(users);
  conversationId ??= await createGroupConversation(users);
  return conversationId;
}

Future<String> createGroupConversation(List<String> users) async {
  String dmId = generateDMId(users);
  var result = await FirebaseFirestore.instance.collection('channels').add({
    'users': users,
    'type': 'dm',
    'dmId': dmId,
    'lastMessage': '',
    'lastMessageTime': Timestamp.now(),
    'lastMessageSender': '',
    'createdAt': Timestamp.now(),
    'recentChatId': '',
  });
      await FirebaseFirestore.instance.collection('recentChat').add({
    'lastMessage': '',
    'lastMessageTime': FieldValue.serverTimestamp(),
    'lastMessageUserId': '',
    'channelId': result.id,
    'users': users,
    'type': 'grp',
  }).then((value) async {
    await FirebaseFirestore.instance
        .collection('channels')
        .doc(result.id)
        .update({'recentChatId': value.id});
  });
  for (var user in users) {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .collection('channels')
        .add({
      'conversationId': result.id,
    });
  }
  return result.id;
}

Future<String?> getGroupConversation(List<String> users) async {
  String dmId = generateDMId(users);

  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection('channels')
      .where('type', isEqualTo: 'grp')
      .where('dmId', isEqualTo: dmId)
      .get();

  if (snapshot.docs.isEmpty) {
    return null;
  }

  return snapshot.docs[0].id;
}

String generateDMId(List<String> users) {
  users.sort();
  return users.join('-');
}
