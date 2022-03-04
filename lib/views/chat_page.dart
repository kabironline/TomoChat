import 'package:chat_app/constants.dart';
import 'package:chat_app/modals/chat_modals.dart';
import 'package:chat_app/modals/user_modals.dart';
import 'package:chat_app/providers/channel.dart';
import 'package:chat_app/providers/user.dart';
import 'package:chat_app/services/get_streams.dart';
import 'package:chat_app/services/messages/send_message.dart';
import 'package:chat_app/utils/timestamp_converter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String? channelImage;
  String? channelName;
  TextEditingController chatBoxTextController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100)).then((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
    return Consumer<MembershipProvider>(
      builder: (context, membershipProvider, child) {
        return Consumer<ChannelProvider>(
            builder: (context, channelProvider, child) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              elevation: 3,
              toolbarHeight: 60,
              backgroundColor: kPrimaryColor,
              title: Row(children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(channelProvider.channelImage!),
                ),
                const SizedBox(width: 10),
                Text(channelProvider.channelName!),
              ]),
            ),
            backgroundColor: kPrimaryColor,
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: getChannelStream(channelProvider.channel!.uid),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return const Text('Start New Converstation');
                      } else {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: ListView.builder(
                            controller: _scrollController,
                            // reverse: true,
                            shrinkWrap: true,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              var timeSent =
                                  snapshot.data.docs[index].data()['time'];
                              BoxDecoration decoration;
                              CrossAxisAlignment alignment;
                              if (snapshot.data.docs[index]
                                      .data()['senderId'] ==
                                  membershipProvider.user.uid) {
                                alignment = CrossAxisAlignment.end;
                                decoration = const BoxDecoration(
                                  color: Color(0xff606082),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(7),
                                    bottomLeft: Radius.circular(7),
                                    topRight: Radius.circular(2),
                                    bottomRight: Radius.circular(7),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 7,
                                        offset: Offset(0, 7))
                                  ],
                                );
                              } else {
                                alignment = CrossAxisAlignment.start;
                                decoration = const BoxDecoration(
                                  color: Color(0xff3B3B51),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(2),
                                    bottomLeft: Radius.circular(7),
                                    topRight: Radius.circular(7),
                                    bottomRight: Radius.circular(7),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 7,
                                        offset: Offset(0, 7))
                                  ],
                                );
                              }
                              return Column(
                                crossAxisAlignment: alignment,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(
                                      top: 8,
                                      bottom: 8,
                                      left: 16,
                                      right: 16,
                                    ),
                                    decoration: decoration,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (channelProvider.channel!.type ==
                                                'grp' &&
                                            snapshot.data.docs[index]
                                                    .data()['senderId'] !=
                                                membershipProvider.user.uid)
                                          Text(
                                              channelProvider
                                                  .grpUsers[snapshot
                                                      .data.docs[index]
                                                      .data()['senderId']]!
                                                  .name,
                                              style: kSubTextStyle),
                                        Text(
                                          snapshot.data.docs[index]['message'],
                                          style: kSubHeadingTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 8),
                                    child: Text(
                                      timeSent == null ? "" : convertTimeStamp(timeSent),
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
                buildTextField(context, channelProvider)
              ],
            ),
          );
        });
      },
    );
  }
  Widget buildTextField(BuildContext context, ChannelProvider channelProvider) {
  TextEditingController chatBoxTextController = TextEditingController();
  return Container(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 2),
          height: 40,
          decoration: BoxDecoration(
            color: kSecondaryColor,
            borderRadius: BorderRadius.circular(100),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 7, offset: Offset(0, 7))
            ],
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 120,
            child: TextFormField(
                controller: chatBoxTextController,
                maxLines: 1,
                decoration: const InputDecoration(
                  errorMaxLines: 0,
                  border: InputBorder.none,
                  isDense: true,
                  hintText: 'Type a message',
                )),
          ),
        ),
        const SizedBox(width: 8),
        FloatingActionButton(
          onPressed: (() {
            if (chatBoxTextController.text != "") {
              var message = chatBoxTextController.text;
              setState(() {
                chatBoxTextController.clear();
              });
              channelProvider.sendMessage(message);
            }
          }),
          mini: true,
          backgroundColor: kAccentColor,
          child: const Icon(Icons.send),
        )
      ],
    ),
  );
}
}

