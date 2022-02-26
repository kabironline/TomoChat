import 'package:chat_app/modals/chat_modals.dart';
import 'package:chat_app/modals/user_modals.dart';
import 'package:chat_app/widgets/message_textfeild.dart';
import 'package:flutter/material.dart';

class GroupChatPage extends StatefulWidget {
  ChannelModel groupId;
  GroupChatPage({required this.groupId});

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Chat'),
      ),
      body: Column(
        children: [
          MessageTextFeildWidget(widget.groupId)
        ],
      ),
    );
  }
}
