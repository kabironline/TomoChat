import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? email;
  String name;
  String image;
  DateTime createdAt;
  String? phoneNumber;
  String? description;
  String uid;

  UserModel({
    this.email,
    this.phoneNumber,
    required this.description,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.uid, 
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
      createdAt: (map['createdAt'].toDate()),
      name: map['displayName'],
      image: map['displayPicture'],
      email: map['email'] ?? "",
      uid: map['uid'],
      description: map['description'],
      phoneNumber: map['phoneNumber'] ?? "",
    );
  }
}
