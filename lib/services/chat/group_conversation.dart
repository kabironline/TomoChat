import 'package:TomoChat/modals/user_modals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<String>> createGroupConversation(List<String> users, String name,
    String image, String description, String adminUser) async {
  String dmId = generateDMId(users);
  var result = await FirebaseFirestore.instance.collection('channels').add({
    'users': users,
    'type': 'grp',
    'dmId': dmId,
    'lastMessage': '',
    'lastMessageTime': FieldValue.serverTimestamp(),
    'lastMessageSender': '',
    'createdAt': FieldValue.serverTimestamp(),
    'createdBy': adminUser,
    'recentChatId': '',
    'name': name,
    'image': image,
    'admins': [adminUser],
    'description': description,
  });
  var recentChatId =
      await FirebaseFirestore.instance.collection('recentChat').add({
    'lastMessage': '',
    'lastMessageTime': FieldValue.serverTimestamp(),
    'lastMessageUserId': '',
    'channelId': result.id,
    'users': users,
    'type': 'grp',
    'name': name,
    'image': image,
  });
  await FirebaseFirestore.instance
      .collection('channels')
      .doc(result.id)
      .update({'recentChatId': recentChatId.id});
  return [result.id, recentChatId.id];
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
