import 'package:cloud_firestore/cloud_firestore.dart';

class DMChannelModel {
  Timestamp createdAt;
  Timestamp lastMessageTime;
  String lastMessage;
  String uid;
  String recentChatId;
  String type;
  List<dynamic> users;

  DMChannelModel({
    required this.recentChatId,
    required this.users,
    required this.type,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.createdAt,
    required this.uid,
  });

  factory DMChannelModel.fromDocument(DocumentSnapshot doc) {
    return DMChannelModel(
      recentChatId: doc['recentChatId'],
      createdAt: doc['createdAt'],
      type: doc['type'],
      lastMessage: doc['lastMessage'],
      lastMessageTime: doc['lastMessageTime'],
      users: doc['users'],
      uid: doc.id,
    );
  }
}
