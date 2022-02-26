import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map>> onSearch(String search, String userUid) async {
  List<Map> searchList = [];
  await FirebaseFirestore.instance
      .collection('users')
      .where("displayName", isEqualTo: search.trim())
      .get()
      .then((value) {
    value.docs.forEach((user) {
      if (user.data()['uid'] != user) {
        searchList.add(user.data());
      }
    });
  });
  return searchList;
}