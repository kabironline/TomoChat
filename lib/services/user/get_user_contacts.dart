import 'package:TomoChat/modals/user_modals.dart';
import 'package:TomoChat/utils/contact_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<UserModel>?> getUsersContacts() async {
  // var start = DateTime.now();
  var users = await FirebaseFirestore.instance.collection('users').get();
  // print(
  //     "Got Firebase Users ${DateTime.now().difference(start).inMilliseconds}");
  var contacts = await getContacts();
  // print("Got Contacts ${DateTime.now().difference(start).inMilliseconds}");
  Map<String, UserModel> usersMap = {};
  List<String> contactsMap = [];

  for (var contact in contacts) {
    try {
      var phoneNumber = removeWhitespaces(contact.phones![0].value.toString());
      contactsMap.add(phoneNumber.substring(phoneNumber.length - 10));
    } catch (e) {
      continue;
    }
  }

  // print("Done number ${DateTime.now().difference(start).inMilliseconds}");
  for (var user in users.docs) {
    String phoneNumber = user.data()['phoneNumber'];
    usersMap[phoneNumber.substring(phoneNumber.length - 10)] =
        UserModel.fromMap(user.data());
  }

  // print("Done user ${DateTime.now().difference(start).inMilliseconds}");
  List<UserModel>? usersOnTomo = [];
  for (String number in usersMap.keys) {
    if (contactsMap.contains(number)) {
      usersOnTomo.add(usersMap[number]!);
    }
  }
  // print("Done tomo ${DateTime.now().difference(start).inMilliseconds}");
  return usersOnTomo;
}

//remove all whitespaces from a string
String removeWhitespaces(String str) {
  return str.replaceAll(RegExp(r'\s+'), '');
}
