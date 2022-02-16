

import 'package:chat_app/modals/chat_modals.dart';
import 'package:chat_app/modals/user_modals.dart';
import 'package:chat_app/services/get_modals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future sendMessage (String message, DMChannelModel chat ,UserModel sender) async {
  //Adding message to the messages collection
  await FirebaseFirestore.instance
      .collection('channels')
      .doc(chat.uid)
      .collection('messages')
      .add({
    'message': message,
    'senderId': sender.uid,
    'time': DateTime.now(),
    'type': 'text',
  }).then((value) async {
    //Updating the last message in the chat 
    await FirebaseFirestore.instance
        .collection('channels')
        .doc(chat.uid)
        .update({
      'lastMessage': message,
      'lastMessageTime': DateTime.now(),
      'lastMessageSenderId': sender.uid,
    }).then((value) async {
      //Updating the last message in the recent chat collection
      DMChannelModel channelModel =
          await getChannelModel(chat.uid);
      FirebaseFirestore.instance
          .collection('recentChat')
          .doc(channelModel.recentChatId)
          .update({
        'lastMessage': message,
        'lastMessageTime': DateTime.now(),
        'lastMessageUserId': sender.uid,
      });
    });
  });
}