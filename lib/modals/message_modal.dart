import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String message;
  String senderUid;
  String type;
  Timestamp time;

  MessageModel(
      {required this.message,
      required this.senderUid,
      required this.type,
      required this.time});

  factory MessageModel.fromDocument(DocumentSnapshot doc) {
    return MessageModel(
      message: doc['message'],
      senderUid: doc['senderUid'],
      type: doc['type'],
      time: doc['time'],
    );
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      message: map['message'],
      senderUid: map['senderId'],
      type: map['type'],
      time: map['time'],
    );
  }
}
