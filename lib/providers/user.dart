import 'dart:io';

import 'package:TomoChat/modals/user_modals.dart';
import 'package:TomoChat/services/get_modals.dart';
import 'package:TomoChat/services/user/set_userdata.dart';
import 'package:TomoChat/services/user/user_sign_in.dart';
import 'package:TomoChat/services/user/register_user.dart' as service;
import 'package:TomoChat/services//user/get_user_contacts.dart' as service;
import 'package:TomoChat/services/user/update_user.dart' as service;
import 'package:flutter/material.dart';

class MembershipProvider extends ChangeNotifier {
  UserModel? _user;

  List<UserModel>? contacts;

  /// Getter for the user
  UserModel get user {
    return _user!;
  }

  Future<bool> get isLoggedIn async {
    try {
      _user ??= await getSignedInUser();
    } catch (e) {
      //doing nothing
    }
    return _user != null;
  }

  Future<List<UserModel>?> getUsersContacts() async {
    contacts ??= await service.getUsersContacts();
    return contacts;    
  }

  Future<List<UserModel>?> refreshContacts()async {
    contacts = await service.getUsersContacts();
    return contacts;    
  }

  Future<UserModel?> logInUser(String? uid) async {
    try {
      _user ??= await getUserModel(uid);
      setLocalUser(_user);
    } catch (e) {
      //Ingoring the issue like always
    }
  }

  /// Register the user
  /// [phone number] is the phone number of the user
  /// [uid] is the otp sent to the user
  /// [name] is the name of the user
  /// [description] is the description of the user
  /// [email] is the email of the user (optional)
  /// [imageUrl] is the image url of the user (optional)
  Future registerUser(String name, String uid, String phoneNumber,
      String? email, String? description, String? imageUrl) async {
    var user = await service.registerUser(
        name, email, phoneNumber, uid, description, imageUrl);
    _user ??= user;
  }

  /// Search for the users with the given [name]
  /// [name] is the name of the user
  Future<List<UserModel>?> searchUsers(String name) async {
    // var users = await onSearch(name, _user!.uid);

    return await getUsersContacts();
  }

  /// Update the user data
  /// [name] is the name of the user (optional)
  /// [description] is the description of the user (optional)
  /// [imageUrl] is the image url of the user (optional)
  Future updateUser(String? name, String? description, File? imageUrl) async {
    _user = await service.updateUser(name, description, imageUrl, _user!);
    setLocalUser(_user);
  }
}
