// getOrCerateConversation returns the conversation for the given users. If the
// conversation does not exist in the firestore collection, it is created.
// It returns the conversation id.
import 'package:cloud_firestore/cloud_firestore.dart';

Future<DocumentSnapshot> getDMChannelFromId (String id) async {
  return await FirebaseFirestore.instance.collection('channels').doc(id).get();
}

Future<String> getOrCreateDMConversation(String uidA, String uidB) async {
  var conversationId = await getDMConversation(uidA, uidB);
  conversationId ??= await createDMConversation(uidA, uidB);
  return conversationId;
}

Future<String> createDMConversation(String uidA, String uidB) async {
  String dmId = generateDMId([uidA, uidB]);
  var result =
      await FirebaseFirestore.instance.collection('channels').add({
    'users': [uidA, uidB],
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
    'users': [uidA, uidB],
    'type': 'dm',
  }).then((value) async {
    await FirebaseFirestore.instance
        .collection('channels')
        .doc(result.id)
        .update({'recentChatId': value.id});
  });
  return result.id;
}

Future<String?> getDMConversation(String uidA, String uidB) async {
  String dmId = generateDMId([uidA, uidB]);

  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection('channels')
      .where('type', isEqualTo: 'dm')
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
