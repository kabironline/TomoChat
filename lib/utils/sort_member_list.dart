import 'package:TomoChat/modals/user_modals.dart';
import 'package:TomoChat/providers/channel.dart';

List<UserModel> sortMemberList(ChannelProvider channelProvider) {
  var users = channelProvider.grpUsers.values.toList();
  List<UserModel> sortedList;
  // Sort the list of users based on being admin and then on the name
  sortedList = users
      .where(
        (user) => channelProvider.channel!.admins!.contains(user.uid),
      )
      .toList();
  sortedList.addAll(
    users.where(
      (user) => !channelProvider.channel!.admins!.contains(user.uid),
    ),
  );
  return sortedList;
}
