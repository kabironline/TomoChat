import 'package:chat_app/modals/chat_modals.dart';
import 'package:chat_app/modals/user_modals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<DMChannelModel> getChannelModel(String channelId) async {
  var firestore = FirebaseFirestore.instance;
  DocumentSnapshot doc =
      await firestore.collection("channels").doc(channelId).get();
  return DMChannelModel.fromDocument(doc);
}

Future<UserModel> getUserModel(var userId) async {
  var firestore = FirebaseFirestore.instance;
  if (userId is String) {
    DocumentSnapshot doc =
        await firestore.collection("users").doc(userId).get();
    return UserModel.fromDocument(doc);
  }
  return UserModel(
      name: userId[0],
      uid: userId[1],
      image: userId[2],
      phoneNumber: userId[3],
      email: userId[4],
      createdAt: DateTime.parse(userId[5],
    ),
  );
}
