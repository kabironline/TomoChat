import 'dart:io';

import 'package:TomoChat/modals/chat_modals.dart';
import 'package:TomoChat/modals/user_modals.dart';
import 'package:TomoChat/services/dm_conversations.dart';
import 'package:TomoChat/services/get_modals.dart';
import 'package:TomoChat/services/get_streams.dart';
import 'package:TomoChat/services/group_conversation.dart';
import 'package:TomoChat/services/messages/send_message.dart';
import 'package:TomoChat/services/upload_image.dart';
import 'package:TomoChat/services/user/get_userdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChannelProvider extends ChangeNotifier {
  ChannelModel? channel;
  UserModel? currentUser;
  UserModel? dmUser;

  Map<String, UserModel> grpUsers = {};

  String? channelImage;
  String? channelName;

  Future setChannel(String channelId, String? image, String? name) async {
    channel = await getChannelModel(channelId);
    if (image != null && name != null || channel?.type == "grp") {
      channelImage = image ?? channel?.image;
      channelName = name ?? channel?.name;
      if (channel?.type == "grp") {
        grpUsers = await getGroupUsers();
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

  void setCurrentUser(UserModel user) {
    currentUser = user;
  }

  Future checkDMChannel(String otherUser) async {
    String channelId =
        await getOrCreateDMConversation(currentUser!.uid, otherUser);
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
    sendTextMessage(text.trimRight(), channel!, currentUser!);
  }

  Future<ChannelModel> createGrpChannel(
      List<String> users, String name, String? description, File? image) async {
    var uids =
        await createGroupConversation(users, name, "", description ?? "");
    await updateGroupImage(image, uids[0], uids[1]);
    return await getChannelModel(uids[0]);
  }
}
