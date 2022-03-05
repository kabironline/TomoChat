import 'package:TomoChat/constants.dart';
import 'package:TomoChat/providers/channel.dart';
import 'package:TomoChat/providers/user.dart';
import 'package:TomoChat/services/get_streams.dart';
import 'package:TomoChat/services/user/get_recent_channel.dart';
import 'package:TomoChat/services/user/user_sign_out.dart';
import 'package:TomoChat/views/chat_page.dart';
import 'package:TomoChat/views/search_page.dart';
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
                itemBuilder: (context, index) {
                  var type = messageStream.data.docs[index].data()['type'];
                  var uid = messageStream.data.docs[index].data()['channelId'];
                  return FutureBuilder(
                    future: getRecentChannelData(
                        type,
                        uid,
                        membership.user.uid,
                        messageStream.data.docs[index].data()['image'],
                        messageStream.data.docs[index].data()['name']),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
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
                          child: Image.network(
                            snapshot.data[0],
                          ),
                        ),
                        title: Text(
                            snapshot.data[1] ??
                                messageStream.data.docs[index].data()['name'],
                            style: kSubHeadingTextStyle),
                        subtitle: Text(
                          messageStream.data.docs[index].data()['lastMessage'],
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        onTap: ()async{
                          ChannelProvider channelProvider =
                              Provider.of<ChannelProvider>(context,
                                  listen: false);
                          await channelProvider.setChannel(
                              uid, snapshot.data[0], snapshot.data[1]);
                          channelProvider.setCurrentUser(membership.user);  
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChatPage(),
                            ),
                          );
                        },
                      );
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
