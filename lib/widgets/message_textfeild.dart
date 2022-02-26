import 'package:chat_app/modals/chat_modals.dart';
import 'package:chat_app/modals/user_modals.dart';
import 'package:chat_app/providers/user.dart';
import 'package:chat_app/services/get_modals.dart';
import 'package:chat_app/services/messages/send_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageTextFeildWidget extends StatefulWidget {
  ChannelModel channel;
  MessageTextFeildWidget(this.channel, {Key? key})
      : super(key: key);

  @override
  _MessageTextFeildWidgetState createState() => _MessageTextFeildWidgetState();
}

class _MessageTextFeildWidgetState extends State<MessageTextFeildWidget> {
  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<MembershipProvider>(
      builder: (context, membershipProvider, child) {
       return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 80,
            height: 50,
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                fillColor: Colors.black,
                hintText: 'Type a message',
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () async {
              String message = _textEditingController.text;
              _textEditingController.clear();
              await sendMessage(message, widget.channel, membershipProvider.user);
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );

      });
  }
}
