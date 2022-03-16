import 'package:TomoChat/modals/chat_modals.dart';
import 'package:TomoChat/modals/user_modals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<String>> createGroupConversation(List<String> users, String name,
    String image, String description, String adminUser) async {
  var result = await FirebaseFirestore.instance.collection('channels').add({
    'users': users,
    'type': 'grp',
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

//Function is used to leave the grp and if the user is admin then it will remove
//the user from the grp and if there are no other admins
//it will pick another user as admin

Future leaveGroup(ChannelModel channel, UserModel user) async {
  if (channel.admins!.contains(user.uid)) {
    //Removing user from admins
    if (channel.admins!.length == 1) {
      await FirebaseFirestore.instance
          .collection('channels')
          .doc(channel.uid)
          .update({
        'admins': [channel.users[channel.users[0] == user.uid ? 1 : 0]]
      });
    } else {
      await FirebaseFirestore.instance
          .collection('channels')
          .doc(channel.uid)
          .update(
              {'admins': channel.admins!.where((e) => e != user.uid).toList()});
    }
  }
  await FirebaseFirestore.instance
      .collection('channels')
      .doc(channel.uid)
      .update({'users': channel.users.where((e) => e != user.uid).toList()});
  await FirebaseFirestore.instance
      .collection('recentChat')
      .doc(channel.recentChatId)
      .update({'users': channel.users.where((e) => e != user.uid).toList()});
}

// deleteGroup is used to delete the channel
Future deleteGroup(ChannelModel channel) async {
  await FirebaseFirestore.instance
      .collection('channels')
      .doc(channel.uid)
      .delete();
  await FirebaseFirestore.instance
      .collection('recentChat')
      .doc(channel.recentChatId)
      .delete();
}

//addUserToGroup is used to add user(s) to the grp
Future addUserToGroup(ChannelModel channel, List<String> users) async {
  await FirebaseFirestore.instance
      .collection('channels')
      .doc(channel.uid)
      .update({'users': channel.users + users});
  await FirebaseFirestore.instance
      .collection('recentChat')
      .doc(channel.recentChatId)
      .update({'users': channel.users + users});
}
