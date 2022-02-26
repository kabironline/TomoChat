import 'package:cloud_firestore/cloud_firestore.dart';

class ChannelModel {
  Timestamp createdAt;
  Timestamp lastMessageTime;
  String lastMessage;
  String uid;
  String recentChatId;
  String type;
  String? name;
  String? image;
  String? description;
  List<dynamic> users;

  ChannelModel({
    required this.recentChatId,
    required this.users,
    required this.type,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.createdAt,
    required this.uid,
    this.name,
    this.image,
    this.description,
  });

  factory ChannelModel.fromDocument(DocumentSnapshot doc) {
    if (doc['type'] == 'grp') {
      return ChannelModel(
        recentChatId: doc['recentChatId'],
        createdAt: doc['createdAt'],
        type: doc['type'],
        lastMessage: doc['lastMessage'],
        lastMessageTime: doc['lastMessageTime'],
        users: doc['users'],
        uid: doc.id,
        name: doc['name'] ?? "",
        image: doc['image'] ?? "",
        description: doc['description'] ?? "",
      );
    }
    return ChannelModel(
        recentChatId: doc['recentChatId'],
        createdAt: doc['createdAt'],
        type: doc['type'],
        lastMessage: doc['lastMessage'],
        lastMessageTime: doc['lastMessageTime'],
        users: doc['users'],
        uid: doc.id,
        name: null,
        image: null,
        description: null,
      );
  }
}
