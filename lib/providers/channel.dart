import 'dart:io';

import 'package:chat_app/modals/chat_modals.dart';
import 'package:chat_app/modals/user_modals.dart';
import 'package:flutter/material.dart';

class ChannelProvider extends ChangeNotifier {
  ChannelModel? _channel;
  UserModel? dmUser;
  List<UserModel>? grpUsers;

  String? channelImage;
  String? channelName;

  ChannelModel? get channel => _channel;
  Future createGrpChannel(List<UserModel> users, String name, String? description,File? image) async {

  }
}
