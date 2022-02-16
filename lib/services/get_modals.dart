import 'package:chat_app/modals/chat_modals.dart';
import 'package:chat_app/modals/user_modals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<DMChannelModel> getChannelModel(String channelId) async {
  var firestore = FirebaseFirestore.instance;
  DocumentSnapshot doc = await firestore.collection("channels").doc(channelId).get();
  return DMChannelModel.fromDocument(doc);
}

Future<UserModel> getUserModel (String userId) async {
  var firestore = FirebaseFirestore.instance;
  DocumentSnapshot doc = await firestore.collection("users").doc(userId).get();
  return UserModel.fromDocument(doc);
}