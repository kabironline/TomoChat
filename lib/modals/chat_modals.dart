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
  DateTime? cachedTime;

  ChannelModel({
    required this.recentChatId,
    required this.users,
    required this.type,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.createdAt,
    required this.uid,
    this.cachedTime,
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
        admins: doc['admins'].cast<String>(),
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
      createdBy: null,
    );
  }
  factory ChannelModel.fromMap(Map<String, dynamic> map) {
    return ChannelModel(
      recentChatId: map['recentChatId'],
      createdAt: Timestamp.fromDate(DateTime.parse(map['createdAt'])),
      type: map['type'],
      lastMessage: map['lastMessage'],
      lastMessageTime: Timestamp.fromDate(DateTime.parse(map['lastMessageTime'])),
      users: map['users'],
      uid: map['uid'],
      admins: map['admins'] is List<dynamic> ? map['admins'].cast<String>() : map['admins'],
      name: map['name'],
      image: map['image'],
      description: map['description'],
      createdBy: map['createdBy'],
      cachedTime: map['cachedTime'] == null ? null : DateTime.parse(map['cachedTime']),
    );
  }
}

Map<String, dynamic> channelModelToMap(ChannelModel channel) {
  return {
    'recentChatId': channel.recentChatId,
    'createdAt': channel.createdAt.toDate().toIso8601String(),
    'type': channel.type,
    'lastMessage': channel.lastMessage,
    'lastMessageTime': channel.lastMessageTime.toDate().toIso8601String(),
    'users': channel.users,
    'uid': channel.uid,
    'admins': channel.admins,
    'name': channel.name,
    'image': channel.image,
    'description': channel.description,
    'createdBy': channel.createdBy,
    'cachedTime': DateTime.now().toIso8601String(),
  };
}
