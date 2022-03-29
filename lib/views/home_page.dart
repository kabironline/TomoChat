import 'package:TomoChat/constants.dart';
import 'package:TomoChat/providers/channel.dart';
import 'package:TomoChat/providers/user.dart';
import 'package:TomoChat/services/get_streams.dart';
import 'package:TomoChat/services/user/get_recent_channel.dart';
import 'package:TomoChat/utils/timestamp_converter.dart';
import 'package:TomoChat/views/chat/chat_page.dart';
import 'package:TomoChat/views/search_page.dart';
import 'package:TomoChat/widgets/user_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // MembershipProvider membership = Provider.of(context)
  @override
  Widget build(BuildContext context) {
    return Consumer<MembershipProvider>(
      builder: (context, membership, child) {
        return Scaffold(
          backgroundColor: kPrimaryColor,
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            toolbarHeight: 60,
            title: const Text('TomoChats'),
            elevation: 0,
            actions: [
              GestureDetector(
                onTap: () async {
                  await Navigator.pushNamed(context, '/profile');
                },
                child: Hero(
                  tag: 'profile_picture',
                  child: ProfilePictureWidget(
                    padding: false,
                    size: 35,
                    imageSrc: membership.user.image,
                  ),
                ),
              ),
              const SizedBox(width: kDefaultPadding),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: "Start a new converstaion",
            backgroundColor: kAccentColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(),
                ),
              );
            },
            child: const Icon(
              Icons.search,
              size: 35,
            ),
          ),
          body: StreamBuilder(
            stream: getRecentMessages(membership.user.uid),
            builder: (BuildContext context, AsyncSnapshot messageStream) {
              if (messageStream.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (messageStream.hasError) {
                return const Center(
                  child: Text('Error'),
                );
              }
              if (messageStream.data.docs.length == 0) {
                return const Center(
                  child: Text('No recent messages'),
                );
              }
              return ListView.builder(
                itemCount: messageStream.data.docs.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var type = messageStream.data.docs[index].data()['type'];
                  var uid = messageStream.data.docs[index].data()['channelId'];

                  return FutureBuilder(
                    future: getRecentChannelData(
                      type,
                      uid,
                      membership.user.uid,
                      messageStream.data.docs[index].data()['image'],
                      messageStream.data.docs[index].data()['name'],
                    ),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ListTile(
                          leading: Hero(
                            tag: "$uid-image",
                            child: ProfilePictureWidget(
                              openImageViewer: true,
                              heroTag: "$uid-image",
                              padding: false,
                              size: 50,
                              imageSrc: snapshot.data[0],
                            ),
                          ),
                          title: Text(
                              snapshot.data[1] ??
                                  messageStream.data.docs[index].data()['name'],
                              style: kSubHeadingTextStyle),
                          subtitle: Text(
                            messageStream.data.docs[index]
                                .data()['lastMessage'],
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                          trailing: Text(
                            messageStream.data.docs[index]
                                        .data()['lastMessageTime'] !=
                                    null
                                ? convertTimeStamp(messageStream
                                    .data.docs[index]
                                    .data()['lastMessageTime'])
                                : "",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                          onTap: () async {
                            ChannelProvider channelProvider =
                                Provider.of<ChannelProvider>(
                              context,
                              listen: false,
                            );
                            channelProvider.setCurrentUser(membership.user);
                            await channelProvider.setChannel(
                                uid, snapshot.data[0], snapshot.data[1]);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChatPage(),
                              ),
                            );
                          },
                        );
                      }
                      return Container();
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
