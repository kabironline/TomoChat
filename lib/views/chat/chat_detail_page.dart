import 'package:TomoChat/constants.dart';
import 'package:TomoChat/modals/user_modals.dart';
import 'package:TomoChat/providers/channel.dart';
import 'package:TomoChat/providers/user.dart';
import 'package:TomoChat/utils/timestamp_converter.dart';
import 'package:TomoChat/widgets/action_button.dart';
import 'package:TomoChat/widgets/grp_bottom_sheet.dart';
import 'package:TomoChat/widgets/user_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatDetailPage extends StatefulWidget {
  ChatDetailPage({Key? key}) : super(key: key);

  @override
  State<ChatDetailPage> createState() => ChatDetailPageState();
}

class ChatDetailPageState extends State<ChatDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MembershipProvider>(
        builder: (context, membershipProvider, child) {
      return Consumer<ChannelProvider>(
          builder: (context, channelProvider, child) {
        return Scaffold(
          backgroundColor: kPrimaryColor,
          // appBar: AppBar(
          //   elevation: 0,
          //   backgroundColor: kPrimaryColor,
          //   title: const Text("Channel Details"),
          // ),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  expandedHeight: 175,
                  backgroundColor: kPrimaryColor,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    // centerTitle: true,
                    title: Text(channelProvider.channelName!),
                    background: Hero(
                      tag: "${channelProvider.channel!.uid}-image",
                      child: profilePictureWidget(
                        // padding: true,
                        size: 150,
                        imageSrc: channelProvider.channelImage!,
                      ),
                    ),
                  ),
                ),
                if (channelProvider.channel!.type == "dm")
                  SliverFillRemaining(
                    // hasScrollBody: false,
                    child: buildDmDetails(
                        context, membershipProvider, channelProvider),
                  ),
                if (channelProvider.channel!.type == "grp")
                  SliverList(
                    delegate: buildGrpDetails(
                      context,
                      membershipProvider,
                      channelProvider,
                    ),
                  ),
              ],
            ),
          ),
        );
      });
    });
  }
}

Widget buildDmDetails(BuildContext context,
    MembershipProvider membershipProvider, ChannelProvider channelProvider) {
  return Container(
    padding: const EdgeInsets.all(kDefaultPadding),
    width: MediaQuery.of(context).size.width,
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icons.message,
              text: "Message"),
          const SizedBox(width: kDefaultPadding),
          ActionButton(
            onPressed: () {
              //TODO Add calling feature
              var url = "tel:${channelProvider.dmUser?.phoneNumber}";
              launch(url);
            },
            icon: Icons.call,
            text: "   Call   ",
            color: kSecondaryColor,
          ),
        ],
      ),
      const SizedBox(height: kDefaultPadding),
      Text("Status", style: kHeadingTextStyle),
      const SizedBox(height: kDefaultPadding),
      Text(channelProvider.dmUser?.description ?? "",
          style: kSubHeadingTextStyle),
      const SizedBox(height: kDefaultPadding),
      Text("Phone Number", style: kHeadingTextStyle),
      const SizedBox(height: kDefaultPadding),
      Text(channelProvider.dmUser?.phoneNumber ?? "",
          style: kSubHeadingTextStyle),
      const SizedBox(height: kDefaultPadding),
      if (channelProvider.dmUser?.email != null)
        Text("Email", style: kHeadingTextStyle),
      if (channelProvider.dmUser?.email != null)
        const SizedBox(height: kDefaultPadding),
      if (channelProvider.dmUser?.email != null)
        Text(
          channelProvider.dmUser?.email ?? "",
          style: kSubHeadingTextStyle,
        ),
      if (channelProvider.dmUser?.email != null)
        const SizedBox(height: kDefaultPadding),
    ]),
  );
}

SliverChildBuilderDelegate buildGrpDetails(BuildContext context,
    MembershipProvider membershipProvider, ChannelProvider channelProvider) {
  List<UserModel> grpUsers =
      channelProvider.grpUsers.entries.toList().map((e) => e.value).toList();
  return SliverChildBuilderDelegate(
    ((context, index) {
      return Column(
        children: [
          //Show When the group was created by the user
          if (index == 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Text(
                    "Created By : ${channelProvider.createdBy!} @ ${channelProvider.createdAt!}",
                    style: kSubHeadingTextStyle,
                  ),
                ),
              ],
            ),
          Container(
            // color: kSecondaryColor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: kSecondaryColor,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: kDefaultPaddingHalf,
            ),
            child: Column(
              children: [
                //Showing the time and by whome was the group created
                ListTile(
                  onTap: () {
                    if (grpUsers[index].uid == membershipProvider.user.uid) {
                      return;
                    }
                    GrpBottomSheet(context, grpUsers[index], channelProvider);
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(grpUsers[index].image),
                  ),
                  title:
                      Text(grpUsers[index].name, style: kSubHeadingTextStyle),
                  subtitle: Text(
                    grpUsers[index].phoneNumber,
                    style: kSubTextStyle,
                  ),
                  //Checking if user is admin and if so, adding admin icon
                  trailing: channelProvider.channel!.admins!.contains(
                          grpUsers[index].uid)
                      ? const Icon(
                          Icons.verified_user,
                          color: Colors.white,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ],
      );
    }),
    childCount: grpUsers.length,
  );
}
