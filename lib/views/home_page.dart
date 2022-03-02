import 'package:chat_app/constants.dart';
import 'package:chat_app/modals/chat_modals.dart';
import 'package:chat_app/modals/user_modals.dart';
import 'package:chat_app/providers/user.dart';
import 'package:chat_app/services/get_modals.dart';
import 'package:chat_app/services/get_streams.dart';
import 'package:chat_app/services/user/retrive_userdata.dart';
import 'package:chat_app/services/user/user_sign_out.dart';
import 'package:chat_app/views/chat_page.dart';
import 'package:chat_app/views/search_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'membership/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              //Log out button
              IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed: () async {
                  signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: "Start a new converstaion",
            backgroundColor: kAccentColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(
                    user: membership.user,
                  ),
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
                itemBuilder: (context, index) {
                  var uid = messageStream.data.docs[index].data()['channelId'];
                  if (messageStream.data.docs[index].data()['type'] == 'dm') {
                    return FutureBuilder(
                        future: getDMOtherUser(
                            messageStream.data.docs[index].data()['channelId'],
                            membership.user.uid),
                        builder: (BuildContext context,
                            AsyncSnapshot<UserModel> snapshot) {
                          if (snapshot.hasData) {
                            return ListTile(
                              leading: Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                    backgroundImage:
                                        NetworkImage(snapshot.data!.image)),
                              ),
                              title: Text(snapshot.data!.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),),
                              subtitle: Text(
                                messageStream.data.docs[index]
                                    .data()['lastMessage'],
                                style: const TextStyle(color: Colors.white),
                              ),
                              onTap: () async {
                                ChannelModel channel = await getChannelModel(
                                  (messageStream.data.docs[index]
                                      .data()['channelId']),
                                );
                                var otherUser = await getDMOtherUser(
                                    channel.uid, membership.user.uid);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      conversation: channel,
                                      otherUser: otherUser,
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Container();
                          }
                        });
                  } else {
                    return FutureBuilder(
                        future: getDMOtherUser(
                            messageStream.data.docs[index].data()['channelId'],
                            membership.user.uid),
                        builder: (BuildContext context,
                            AsyncSnapshot<UserModel> snapshot) {
                          if (snapshot.hasData) {
                            return ListTile(
                              leading: Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: ClipOval(
                                    child: Image.network(messageStream
                                        .data.docs[index]
                                        .data()['image'])),
                              ),
                              title: Text(
                                  messageStream.data.docs[index].data()['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                messageStream.data.docs[index]
                                    .data()['lastMessage'],
                                style: const TextStyle(color: Colors.white),
                              ),
                              onTap: () async {
                                ChannelModel channel = await getChannelModel(
                                  (messageStream.data.docs[index]
                                      .data()['channelId']),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      conversation: channel,
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Container();
                          }
                        });
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
