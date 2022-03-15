import 'package:cloud_firestore/cloud_firestore.dart';

class ChannelModel {
  String uid; // Channel ID
  String lastMessage;
  String recentChatId;
  String type;
  String? name;
  String? image;
  String? description;
  String? createdBy;

  List<dynamic> users;
  List<String>? admins;

  Timestamp createdAt;
  Timestamp lastMessageTime;

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
    this.admins,
    this.createdBy,
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
        admins:  doc['admins'].cast<String>(),
        name: doc['name'] ?? "",
        image: doc['image'] ?? "",
        description: doc['description'] ?? "",
        createdBy: doc['createdBy'] ?? "",
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
        createdBy: null 
      );
  }
}
