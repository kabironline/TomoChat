import 'package:TomoChat/modals/user_modals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<UserModel>> onSearch(String search, String userUid) async {
  List<UserModel> searchList = [];
  await FirebaseFirestore.instance
      .collection('users')
      .where("displayName", isEqualTo: search.trim())
      .get()
      .then((value) {
    for (var user in value.docs) {
      if (user.data()['uid'] != user) {
        searchList.add(UserModel.fromMap(user.data()));
      }
    }
  });
  return searchList;
}