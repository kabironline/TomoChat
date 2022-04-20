import 'package:localstore/localstore.dart';

Future clearUserData() async {
  var channels = await Localstore.instance.collection("channels").get();
  for (var channel in channels!.keys) {
    // print("channel ${channel}");
    await Localstore.instance.collection("channels").doc(channel).delete();
  }
  var users = await Localstore.instance.collection("users").get();
  for (var user in users!.keys) {
    await Localstore.instance.collection("users").doc(user).delete();
  }
}
