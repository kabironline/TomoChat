import 'dart:io';

import 'package:TomoChat/modals/chat_modals.dart';
import 'package:TomoChat/modals/user_modals.dart';
import 'package:TomoChat/services/clear_userdata.dart';
import 'package:TomoChat/services/image_funcs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:localstore/localstore.dart';

Future<List<String>> createGroupConversation(
    List<String> users, String name, String image, String description, String adminUser) async {
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

Future leaveGroup(ChannelModel channel, UserModel user) async {
  if (channel.admins!.contains(user.uid)) {
    //Removing user from admins
    if (channel.admins!.length == 1) {
      await FirebaseFirestore.instance.collection('channels').doc(channel.uid).update({
        'admins': [channel.users[channel.users[0] == user.uid ? 1 : 0]]
      });
    } else {
      await FirebaseFirestore.instance
          .collection('channels')
          .doc(channel.uid)
          .update({'admins': channel.admins!.where((e) => e != user.uid).toList()});
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
  await Localstore.instance.collection("channels").doc(channel.uid).delete();
}

Future removeUserFromGroup(ChannelModel channelModel, String uid) async {
  var updatedModel = ChannelModel(
    recentChatId: channelModel.recentChatId,
    createdAt: channelModel.createdAt,
    type: channelModel.type,
    lastMessage: channelModel.lastMessage,
    lastMessageTime: channelModel.lastMessageTime,
    uid: channelModel.uid,
    name: channelModel.name,
    image: channelModel.image,
    description: channelModel.description,
    createdBy: channelModel.createdBy,
    users: channelModel.users.where((e) => e != uid).toList(),
    admins: channelModel.admins!.where((e) => e != uid).toList(),
  );

  //Getting all the users in 'channels'
  await FirebaseFirestore.instance
      .collection('channels')
      .doc(channelModel.uid)
      .update({'users': channelModel.users.where((e) => e != uid).toList()});
  //If user is admin, removing user from admins
  await FirebaseFirestore.instance
      .collection('channels')
      .doc(channelModel.uid)
      .update({'admins': updatedModel.admins});
  //Removing User from the recentChat collection
  await FirebaseFirestore.instance
      .collection('recentChat')
      .doc(channelModel.recentChatId)
      .update({'users': updatedModel.users});

  deleteChannelModel(channelModel.uid);
  await Localstore.instance
      .collection("channels")
      .doc(updatedModel.uid)
      .set(channelModelToMap(updatedModel));
}

// deleteGroup is used to delete the channel
Future deleteGroup(ChannelModel channel) async {
  await FirebaseFirestore.instance.collection('channels').doc(channel.uid).delete();
  await FirebaseFirestore.instance.collection('recentChat').doc(channel.recentChatId).delete();
  try {
    await FirebaseStorage.instance.ref().child('group/${channel.uid}/profile').delete();
  } catch (e) {
    //Doing nothing cause it throws error when there is a default pfp
  }
}

// updateGroup is used to update the channel
Future<ChannelModel> updateGroup(
    String? name, String? description, File? image, ChannelModel channel) async {
  ChannelModel upadtedModel = channel;
  if (name != null) {
    upadtedModel.name = name;
    await FirebaseFirestore.instance.collection('channels').doc(channel.uid).update({'name': name});
    await FirebaseFirestore.instance
        .collection('recentChat')
        .doc(channel.recentChatId)
        .update({'name': name});
  }
  if (description != null) {
    upadtedModel.description = description;
    await FirebaseFirestore.instance
        .collection('channels')
        .doc(channel.uid)
        .update({'description': description});
    await FirebaseFirestore.instance
        .collection('recentChat')
        .doc(channel.recentChatId)
        .update({'description': description});
  }
  if (image != null) {
    var imageURL = await updateGroupImage(
      image,
      channel.uid,
      channel.recentChatId,
    );
    upadtedModel.image = imageURL;
  }
  var local = Localstore.instance;
  await local.collection('channels').doc(channel.uid).delete();
  await local.collection('channels').doc(channel.uid).set(channelModelToMap(upadtedModel));
  return upadtedModel;
}

//addUserToGroup is used to add user(s) to the grp
Future addUserToGroup(ChannelModel channel, List<String> users) async {
  //Remove the users already in the grp from the list of new users
  users = users.where((e) => !channel.users.contains(e)).toList();
  await FirebaseFirestore.instance
      .collection('channels')
      .doc(channel.uid)
      .update({'users': channel.users + users});
  await FirebaseFirestore.instance
      .collection('recentChat')
      .doc(channel.recentChatId)
      .update({'users': channel.users + users});
}
