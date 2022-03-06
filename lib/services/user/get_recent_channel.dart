import 'package:TomoChat/services/user/get_userdata.dart';

Future getRecentChannelData(
    String type, String channelId, String userId, String? image, String? name) async {
  if (type == "dm" ) {
    var otherUser = await getDMOtherUser(channelId, userId);
    return [otherUser.image, otherUser.name];
  } else {
    return [image, name];
  }
}
