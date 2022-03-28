import 'dart:io';

import 'package:TomoChat/modals/chat_modals.dart';
import 'package:TomoChat/modals/user_modals.dart';
import 'package:TomoChat/services/chat/admin.dart';
import 'package:TomoChat/services/chat/dm_conversations.dart';
import 'package:TomoChat/services/chat/message.dart';
import 'package:TomoChat/services/get_modals.dart';
import 'package:TomoChat/services/get_streams.dart';
import 'package:TomoChat/services/chat/group_conversation.dart' as grpService;
import 'package:TomoChat/services/messages/send_message.dart';
import 'package:TomoChat/services/image_funcs.dart';
import 'package:TomoChat/services/user/get_userdata.dart';
import 'package:TomoChat/utils/find_link.dart';
import 'package:TomoChat/utils/timestamp_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChannelProvider extends ChangeNotifier {
  ChannelModel? channel;
  UserModel? currentUser;
  UserModel? dmUser;

  Map<String, UserModel> grpUsers = {};
  bool? isAdmin;
  String? createdBy;
  String? createdAt;
  String? channelImage;
  String? channelName;

  Future setChannel(String channelId, String? image, String? name) async {
    channel = await getChannelModel(channelId);
    if (image != null && name != null || channel?.type == "grp") {
      channelImage = image ?? channel?.image;
      channelName = name ?? channel?.name;
      if (channel?.type == "grp") {
        grpUsers.clear();
        grpUsers = await getGroupUsers();
        grpUsers[currentUser!.uid] = currentUser!;
        isAdmin = channel!.admins?.contains(currentUser!.uid);
        createdBy = grpUsers[channel!.createdBy]?.uid == currentUser?.uid
            ? "You"
            : grpUsers[channel!.createdBy]?.name;
        createdAt = convertTimeStamp(channel!.createdAt) + " on " + getDate(channel!.createdAt);
      }
      if (channel?.type == "dm") {
        dmUser = await getDMOtherUser(channel!.uid, currentUser!.uid);
      }
    } else {
      var value = await getDMOtherUser(channel!.uid, currentUser!.uid);
      dmUser = value;
      channelImage = dmUser?.image;
      channelName = dmUser?.name;
    }
    notifyListeners();
  }

  Future updateChannel(String? name, String? description, File? image) async {
    channel = await grpService.updateGroup(name, description, image, channel!);
    channelName = name ?? channel?.name;
    channelImage = image != null ? channel?.image : channelImage;
    notifyListeners();
  }

  void setCurrentUser(UserModel user) {
    currentUser = user;
  }

  Future checkDMChannel(String otherUser) async {
    String channelId = await getOrCreateDMConversation(currentUser!.uid, otherUser);
    await setChannel(channelId, null, null);
  }

  Future disposeChannel() async {
    channel = null;
    notifyListeners();
  }

  Future<Map<String, UserModel>> getGroupUsers() async {
    for (var userUid in channel!.users) {
      if (userUid != currentUser?.uid) {
        var userDetail = await getUserModel(userUid);
        grpUsers.addEntries([MapEntry(userUid, userDetail)]);
      }
    }
    return grpUsers;
  }

  // TODO: Add paging. By default load only x number of messages.
  // When user scroll to the top of the screen, load more messages.
  // This function should accept page number as a parameter.
  Stream<QuerySnapshot<Object?>> getMessages() {
    var messageStream = getChannelStream(channel!.uid);
    return messageStream;
  }

  Future sendMessage(String text) async {
    var links = findLinks(text);
    if (links == null) {
      await sendTextMessage(text.trimRight(), channel!, currentUser!, 'text', links);
      return;
    }
    if (isOnlyLink(text)) {
      List<String> imageLinks = [];
      for (var link in links) {
        if (isImageLink(link)) {
          await sendTextMessage(text.trimRight(), channel!, currentUser!, 'media', [link]);
          imageLinks.add(link);
        }
      }
      for (var imageLink in imageLinks) {
        links.remove(imageLink);
      }
      if (links.isNotEmpty) {
        await sendTextMessage(text.trimRight(), channel!, currentUser!, 'link', links);
      }
      return;
    }
    if (isOnlyLink(text)) {
      await sendTextMessage(text.trimRight(), channel!, currentUser!, 'link', links);
      return;
    }
    await sendTextMessage(text.trimRight(), channel!, currentUser!, 'text-link', links);
  }

  Future deleteMessage (DocumentReference messageId) async {
    return await deleteMessageFromChannel(channel!, messageId);
  }

  Future copyMessage (String message) async {
    return await copyMessageToChannel(message);
  }

  Future addAdmin(String userId) async {
    await addAdminToChannel(userId, channel!.uid);
    channel!.admins!.add(userId);
    notifyListeners();
  }

  Future removeAdmin(String userId) async {
    await removeAdminFromChannel(userId, channel!.uid);
    channel!.admins!.remove(userId);
    notifyListeners();
  }

  Future leaveChannel() async {
    await grpService.leaveGroup(channel!, currentUser!);
    await disposeChannel();
  }

  Future deleteChannel() async {
    await grpService.deleteGroup(channel!);
    await disposeChannel();
  }

  Future addUserToChannel(List<String> userIds) async {
    //Remove Users already in the channel from the new list of users
    userIds.removeWhere((userId) => channel!.users.contains(userId));
    await grpService.addUserToGroup(channel!, userIds);
    for (var userId in userIds) {
      if (userId != currentUser?.uid) {
        var userDetail = await getUserModel(userId);
        grpUsers.addEntries([MapEntry(userId, userDetail)]);
      }
    }
    //Adding users indivually to the channel
    for (var userId in userIds) {
      if (userId != currentUser?.uid) {
        channel!.users.add(userId);
      }
    }
    notifyListeners();
  }

  Future removeUserFromGroup(String uid) async {
    await grpService.removeUserFromGroup(channel!, uid);
    channel!.users.remove(uid);
    //If user is admin, remove admin role
    if (channel!.admins!.contains(uid)) {
      channel!.admins!.remove(uid);
    }
    grpUsers.remove(uid);

    notifyListeners();
  }

  Future<ChannelModel> createGrpChannel(
      List<String> users, String name, String? description, File? image) async {
    var uids = await grpService.createGroupConversation(
        users, name, "", description ?? "", currentUser!.uid);
    await updateGroupImage(image, uids[0], uids[1]);
    return await getChannelModel(uids[0]);
  }
}
