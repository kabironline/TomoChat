import 'package:TomoChat/modals/chat_modals.dart';
import 'package:TomoChat/modals/user_modals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localstore/localstore.dart';

Future<ChannelModel> getChannelModel(String channelId) async {
  var firestore = FirebaseFirestore.instance;
  var local = Localstore.instance;
  var channel = await local.collection("channels").doc(channelId).get();
  if (channel != null) {
    var channelData = ChannelModel.fromMap(channel);
    if (channelData.cachedTime!.difference(DateTime.now()).inDays > 1) {
      await Localstore.instance.collection("channels").doc(channelId).delete();
      return channelData;
    }
    return channelData;
  } else {
    DocumentSnapshot doc = await firestore.collection("channels").doc(channelId).get();
    var channelDoc = ChannelModel.fromDocument(doc);
    local.collection("channels").doc(channelId).set(channelModelToMap(channelDoc));
    return ChannelModel.fromDocument(doc);
  }
}

Future<UserModel> getUserModel(var userId) async {
  var firestore = FirebaseFirestore.instance;
  if (userId is String) {
    var local = Localstore.instance;
    var user = await local.collection("users").doc(userId).get();
    if (user?.isEmpty == false) {
      var userData = UserModel.fromMap(user!);
      if (userData.cachedTime!.difference(DateTime.now()).inDays > 1) {
        await Localstore.instance.collection("users").doc(userId).delete();
        return userData;
      } else {
        return userData;
      }
    } else {
      DocumentSnapshot doc = await firestore.collection("users").doc(userId).get();
      var userDoc = UserModel.fromDocument(doc);
      local.collection("users").doc(userId).set((userModelToMap(userDoc)));
      return userDoc;
    }
  }
  return UserModel(
    name: userId[0],
    uid: userId[1],
    image: userId[2],
    phoneNumber: userId[3],
    email: userId[4],
    createdAt: DateTime.parse(
      userId[5],
    ),
    description: userId[6],
  );
}
