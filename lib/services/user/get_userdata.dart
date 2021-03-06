import 'package:TomoChat/services/get_modals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:TomoChat/modals/user_modals.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<UserModel> getDMOtherUser(String chatId, String userId) async {
  DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('channels').doc(chatId).get();

  var uidList = snapshot.data()!['users'];
  String uid;
  if (uidList[0] == userId) {
    uid = uidList[1];
  } else {
    uid = uidList[0];
  }
  return getUserModel(uid);
}

Future<UserModel?> checkUserExistsLocally(String userId) async {
  var prefs = await SharedPreferences.getInstance();
  var user = prefs.getString('users/$userId');
  if (user != null) {
    return getUserModel(user);
  }
  return null;
}
