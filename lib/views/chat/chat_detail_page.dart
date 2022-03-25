import 'package:TomoChat/constants.dart';
import 'package:TomoChat/modals/user_modals.dart';
import 'package:TomoChat/providers/channel.dart';
import 'package:TomoChat/providers/user.dart';
import 'package:TomoChat/views/search_page.dart';
import 'package:TomoChat/widgets/action_button.dart';
import 'package:TomoChat/widgets/grp_options_bottom_sheet.dart';
import 'package:TomoChat/widgets/grp_user_option_bottom_sheet.dart';
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
  bool isDefualtProfilePicture = true;
  double height = 200;
  @override
  Widget build(BuildContext context) {
    return Consumer<MembershipProvider>(builder: (context, membershipProvider, child) {
      return Consumer<ChannelProvider>(builder: (context, channelProvider, child) {
        if (channelProvider.channelImage != kdefualtUserProfilePicture &&
            channelProvider.channelImage != kDefualtGroupProfilePicture) {
          isDefualtProfilePicture = false;
          height = MediaQuery.of(context).size.width;
        }
        return Scaffold(
          backgroundColor: kPrimaryColor,
          floatingActionButton: _buildFloatingActionButton(context, channelProvider),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  //Action Button for Admin
                  //That is used to delete the channel or
                  //edit channel details or leave ther channel
                  //If the user is not an admin then the action button will be null
                  actions: channelProvider.channel!.type == "grp"
                      ? [
                          IconButton(
                            onPressed: () async {
                              await GrpDetailBottomSheet(
                                  context, membershipProvider.user, channelProvider);
                            },
                            icon: const Icon(Icons.more_vert_rounded),
                          )
                        ]
                      : [],
                  pinned: true,
                  floating: true,
                  expandedHeight: height,
                  backgroundColor: kPrimaryColor,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    // centerTitle: true,
                    title: Text(channelProvider.channelName!),
                    background: Hero(
                      tag: "${channelProvider.channel!.uid}-image",
                      child: Container(
                        height: height,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(channelProvider.channelImage!),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.7, 1],
                              colors: [
                                Colors.transparent,
                                Color.fromRGBO(
                                  0,
                                  0,
                                  0,
                                  isDefualtProfilePicture ? 0 : 0.8,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (channelProvider.channel!.type == "dm")
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: buildDmDetails(context, membershipProvider, channelProvider),
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

Widget? _buildFloatingActionButton(BuildContext context, ChannelProvider channelProvider) {
  bool isUserAdmin = channelProvider.isAdmin ?? false;
  try {
    if (channelProvider.channel!.type == "grp" && isUserAdmin) {
      return FloatingActionButton(
        backgroundColor: kAccentColor,
        child: const Icon(
          Icons.group_add,
          color: Colors.white,
        ),
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchPage(
                  isUserSelect: true,
                  channelProvider: channelProvider,
                ),
              ));
        },
      );
    }
  } catch (e) {
    //Doing nothing cause the channel is null after its deleted
  }
  return null;
}

Widget buildDmDetails(
    BuildContext context, MembershipProvider membershipProvider, ChannelProvider channelProvider) {
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
      Text(channelProvider.dmUser?.description ?? "", style: kSubHeadingTextStyle),
      const SizedBox(height: kDefaultPadding),
      Text("Phone Number", style: kHeadingTextStyle),
      const SizedBox(height: kDefaultPadding),
      Text(channelProvider.dmUser?.phoneNumber ?? "", style: kSubHeadingTextStyle),
      const SizedBox(height: kDefaultPadding),
      if (channelProvider.dmUser?.email != null) Text("Email", style: kHeadingTextStyle),
      if (channelProvider.dmUser?.email != null) const SizedBox(height: kDefaultPadding),
      if (channelProvider.dmUser?.email != null)
        Text(
          channelProvider.dmUser?.email ?? "",
          style: kSubHeadingTextStyle,
        ),
      if (channelProvider.dmUser?.email != null) const SizedBox(height: kDefaultPadding),
    ]),
  );
}

SliverChildBuilderDelegate buildGrpDetails(
    BuildContext context, MembershipProvider membershipProvider, ChannelProvider channelProvider) {
  List<UserModel> grpUsers = channelProvider.grpUsers.entries.toList().map((e) => e.value).toList();
  return SliverChildBuilderDelegate(
    ((context, index) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Show When the group was created by the user
          if (index == 0) _buildChannelDetails(context, channelProvider),
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
                    GrpUserBottomSheet(context, grpUsers[index], channelProvider);
                  },
                  leading: Hero(
                    tag: "${grpUsers[index].uid}-image",
                    child: profilePictureWidget(
                      padding: false,
                      size: 50,
                      heroTag: "${grpUsers[index].uid}-image",
                      imageSrc: grpUsers[index].image,
                    ),
                  ),
                  title: Text(grpUsers[index].name, style: kSubHeadingTextStyle),
                  subtitle: Text(
                    grpUsers[index].phoneNumber,
                    style: kSubTextStyle,
                  ),
                  //Checking if user is admin and if so, adding admin icon
                  trailing: channelProvider.channel!.admins!.contains(grpUsers[index].uid)
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

Widget _buildChannelDetails(BuildContext context, ChannelProvider channelProvider) {
  return Container(
    width: MediaQuery.of(context).size.width,
    color: kSecondaryColor,
    margin: const EdgeInsets.symmetric(vertical: kDefaultPadding),
    padding: const EdgeInsets.symmetric(
      vertical: kDefaultPadding,
      horizontal: kDefaultPadding,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Created by", style: kHeadingTextStyle),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: kDefaultPaddingHalf,
          ),
          child: Text(
            "${channelProvider.createdBy!} @ ${channelProvider.createdAt!}",
            style: kSubHeadingTextStyle,
          ),
        ),
        if (channelProvider.channel?.description != "")
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddingHalf),
            child: Text(
              "Description",
              style: kHeadingTextStyle,
            ),
          ),
        if (channelProvider.channel?.description != "")
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: kDefaultPaddingHalf,
            ),
            child: Text(
              channelProvider.channel?.description ?? "",
              style: kSubHeadingTextStyle,
            ),
          ),
      ],
    ),
  );
}
