import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? email;
  String name;
  String image;
  DateTime createdAt;
  String? phoneNumber;
  String uid;

  UserModel({
    this.email,
    this.phoneNumber,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.uid,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      createdAt: (doc['createdAt'].toDate()),
      name: doc['displayName'],
      image: doc['displayPicture'],
      email: doc['email'],
      uid: doc['uid'],
    );
  }
}
