import 'package:TomoChat/modals/user_modals.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future setLocalUser(var user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (user is UserModel) {
  prefs.setStringList('user', [
    user.name,
    user.uid,
    user.image,
    user.phoneNumber,
    user.email ?? "",
    user.createdAt.toIso8601String(),
    user.description ?? "",
  ]);
  }else if (user is List<String>) {
    prefs.setStringList('user', user);
  }
}
