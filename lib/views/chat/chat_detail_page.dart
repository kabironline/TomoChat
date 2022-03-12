import 'package:TomoChat/constants.dart';
import 'package:TomoChat/modals/user_modals.dart';
import 'package:TomoChat/providers/channel.dart';
import 'package:TomoChat/providers/user.dart';
import 'package:TomoChat/utils/timestamp_converter.dart';
import 'package:TomoChat/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.network(
                          channelProvider.channelImage!,
                          fit: BoxFit.fitHeight,
                        ),
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
                      // hasScrollBody: false,

                      delegate: buildGrpDetails(
                          context, membershipProvider, channelProvider)
                      // child: buildGrpDetails(context, membershipProvider, channelProvider),
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
          ActionButton(onPressed: () {}, icon: Icons.message, text: "Message"),
          const SizedBox(width: kDefaultPadding),
          ActionButton(
            onPressed: () {},
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
        Text(channelProvider.dmUser?.email ?? "", style: kSubHeadingTextStyle),
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
      return Container(
        // color: kSecondaryColor,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: kSecondaryColor,
        ),
        margin: const EdgeInsets.all(kDefaultPadding),
        // padding: const EdgeInsets.all(kDefaultPadding / 2),
        child: ListTile(
          onTap: () {
            showBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container();
              },
            );
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(grpUsers[index].image),
          ),
          title: Text(grpUsers[index].name, style: kSubHeadingTextStyle),
          subtitle: Text(
            grpUsers[index].phoneNumber,
            style: kSubTextStyle,
          ),
        ),
      );
    }),
    childCount: grpUsers.length,
  );
}

Widget buildGrpDetail(BuildContext context,
    MembershipProvider membershipProvider, ChannelProvider channelProvider) {
  List<UserModel> grpUsers =
      channelProvider.grpUsers.entries.toList().map((e) => e.value).toList();
  return Container(
    padding: const EdgeInsets.all(kDefaultPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Members", style: kHeadingTextStyle),
        const SizedBox(height: kDefaultPadding),
        Container(
          height: MediaQuery.of(context).size.height * 0.45,
          child: ListView.builder(
            itemCount: channelProvider.grpUsers.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
                child: ListTile(
                  onTap: () {
                    showBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: Column(children: [
                            
                          ]),
                        );
                      },
                    );
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
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
