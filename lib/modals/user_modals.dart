import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String image;
  DateTime createdAt;
  String phoneNumber;
  String uid;
  String? email;
  String? description;
  DateTime? cachedTime;

  UserModel({
    this.email,
    required this.phoneNumber,
    required this.description,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.uid,
    this.cachedTime,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      createdAt: (doc['createdAt'].toDate()),
      name: data['displayName'],
      image: data['displayPicture'],
      email: data['email'],
      uid: data['uid'],
      phoneNumber: data['phoneNumber'],
      description: data['description'],
    );
  }
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      createdAt: map['createdAt'] is String
          ? DateTime.parse(map['createdAt'])
          : map["createdAt"] is Timestamp
              ? map['createdAt'].toDate()
              : map['createdAt'],
      name: map['displayName'],
      image: map['displayPicture'],
      email: map['email'] ?? "",
      uid: map['uid'],
      description: map['description'],
      phoneNumber: map['phoneNumber'],
      cachedTime: map['cachedTime'] == null ? null : DateTime.parse(map['cachedTime']),
    );
  }
}

//Convert UserModel to Map
Map<String, dynamic> userModelToMap(UserModel user) {
  return {
    'createdAt': user.createdAt.toIso8601String(),
    'displayName': user.name,
    'displayPicture': user.image,
    'email': user.email,
    'uid': user.uid,
    'phoneNumber': user.phoneNumber,
    'description': user.description,
    'cachedTime': DateTime.now().toIso8601String(),
  };
}
