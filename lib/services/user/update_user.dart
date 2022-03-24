import 'dart:io';

import 'package:TomoChat/modals/user_modals.dart';
import 'package:TomoChat/services/image_funcs.dart';
import 'package:TomoChat/services/user/user_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Update user data in firestore
/// [name] is the name of the user (optional)
/// [description] is the description of the user (optional)
/// [image] is the image of the user (optional)
Future updateUser (String? name, String? description, File? image, UserModel user) async {
  if (user != null) {
    if (name != null) {
      user.name = name;
    }
    if (description != null) {
      user.description = description;
    }
    if (image != null) {
      var imageURL = await uploadImage(image, 'users/${user.uid}/profile_image');
      user.image = imageURL;
    }
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'displayName': user.name,
      'description': user.description,
      'displayPicture': user.image,
    });
  }
  UserModel updatedUser = UserModel(
    name: user.name,
    description: user.description,
    image: user.image,
    uid: user.uid,
    email: user.email,
    phoneNumber: user.phoneNumber,
    createdAt: user.createdAt,
  );
  return updatedUser;
}