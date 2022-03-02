import 'package:chat_app/modals/user_modals.dart';
import 'package:chat_app/services/search_user.dart';
import 'package:chat_app/services/user/user_sign_in.dart';
import 'package:chat_app/services/user/register_user.dart' as service;
import 'package:flutter/material.dart';

class MembershipProvider extends ChangeNotifier {
  UserModel? _user;

  /// Getter for the user
  UserModel get user {
    return _user!;
  }

  Future<bool> get isLoggedIn async {
    try {
      _user ??= await getSignedInUser();
    } catch (e) {}
    return _user != null;
  }

  /// Register the user
  /// [phone number] is the phone number of the user
  /// [uid] is the otp sent to the user
  /// [name] is the name of the user
  /// [email] is the email of the user (optional)
  /// [imageUrl] is the image url of the user (optional)
  Future registerUser(String name, String uid, String phoneNumber,
      String? email, String? imageUrl) async {
    var user = await service.registerUser(name, email, phoneNumber, uid, imageUrl);
    _user ??= user;
  }

  /// Search for the users with the given [name]
  /// [name] is the name of the user
  Future<List<UserModel>> searchUsers(String name) async {
    var users = await onSearch(name, _user!.uid);
    return users;
  }
}
