import 'package:TomoChat/constants.dart';
import 'package:TomoChat/providers/channel.dart';
import 'package:TomoChat/providers/user.dart';
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
          appBar: AppBar(
            elevation: 0,
            backgroundColor: kPrimaryColor,
            title: const Text("Channel Details"),
          ),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: kDefaultPadding),
                Hero(
                  tag: "${channelProvider.channel!.uid}-image",
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(0, 0),
                          blurRadius: 30,
                          spreadRadius: 0
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage(channelProvider.channelImage!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: 150,
                    height: 150,
                  ),
                ),
                const SizedBox(height: kDefaultPadding),
                Text(
                  channelProvider.channelName!,
                  style: const TextStyle(fontSize: 30),
                ),
                const SizedBox(height: kDefaultPadding),
                if (channelProvider.channel!.type == "dm")
                  buildDmDetails(context, membershipProvider, channelProvider),
                if (channelProvider.channel!.type == "grp")
                  buildGrpDetails(context, membershipProvider, channelProvider),
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
    child: SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ActionButton(onPressed: () {}, icon: Icons.message, text: "Message"),
            const SizedBox(width: kDefaultPadding),
            ActionButton(onPressed: () {}, icon: Icons.call, text: "   Call   ", color: kSecondaryColor,),
            
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
          Text(channelProvider.dmUser?.email ?? "",
              style: kSubHeadingTextStyle),
        if (channelProvider.dmUser?.email != null)
          const SizedBox(height: kDefaultPadding),
      ]),
    ),
  );
}

Widget buildGrpDetails(BuildContext context,
    MembershipProvider membershipProvider, ChannelProvider channelProvider) {
  return Container(
    padding: const EdgeInsets.all(kDefaultPadding),
  );
}
