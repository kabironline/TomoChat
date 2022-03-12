import 'package:TomoChat/modals/user_modals.dart';
import 'package:TomoChat/utils/contact_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';

Future<List<UserModel>?> getUsersContacts() async {
  var users = await FirebaseFirestore.instance.collection('users').get();
  var contacts = await getContacts();
  Map<String, UserModel> usersMap = {};
  List<String> contactsMap = [];
  for (var contact in contacts) {
    var phoneNumber = removeWhitespaces(contact.phones!.first.value.toString());
    try {
      contactsMap.add(phoneNumber.substring(phoneNumber.length - 10));
    } catch (e) {
      continue;
    }
  }
  for (var user in users.docs) {
    String phoneNumber = user.data()['phoneNumber'];
    usersMap[phoneNumber.substring(phoneNumber.length - 10)] =
        UserModel.fromMap(user.data());
  }
  List<UserModel>? usersOnTomo = [];
  for (String number in usersMap.keys) {
    if (contactsMap.contains(number)) {
      usersOnTomo.add(usersMap[number]!);
    }
  }
  return usersOnTomo;
}

//remove all whitespaces from a string
String removeWhitespaces(String str) {
  return str.replaceAll(RegExp(r'\s+'), '');
}
