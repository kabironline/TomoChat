import 'package:localstore/localstore.dart';

Future clearUserData() async {
  var local = Localstore.instance;
  var channels = await local.collection("/channels/").get();
  if (channels != null) {
    for (var channel in channels.keys) {
      await local.collection("/channels/").doc(channel.substring(11)).delete();
    }
  }
  var users = await local.collection("/users/").get();
  if (users != null) {
    for (var user in users.keys) {
      await local.collection("/users/").doc(user.substring(9)).delete();
    }
  }
  users = await local.collection("/users/").get();
}

Future deleteUserModel(String id) async {
  var local = Localstore.instance;
  await local.collection("/users/").doc(id).delete();
}

Future deleteChannelModel(String id) async {
  var local = Localstore.instance;
  await local.collection("/channels/").doc(id).delete();
}
