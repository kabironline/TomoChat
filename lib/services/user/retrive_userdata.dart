import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/modals/user_modals.dart';

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
  var user =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
  return UserModel.fromDocument(user);
}
