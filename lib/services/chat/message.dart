import 'package:TomoChat/modals/chat_modals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

///Fuction to delete message from a channel
Future deleteMessageFromChannel(ChannelModel channel, DocumentReference messageId) async {
  FirebaseFirestore.instance.runTransaction((transaction) async {
    transaction.delete(messageId);
  });
}

Future copyMessageToChannel(String message) async {
  Clipboard.setData(ClipboardData(text: message));
}
