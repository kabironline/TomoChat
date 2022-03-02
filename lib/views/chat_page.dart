import 'package:chat_app/constants.dart';
import 'package:chat_app/modals/chat_modals.dart';
import 'package:chat_app/modals/user_modals.dart';
import 'package:chat_app/providers/user.dart';
import 'package:chat_app/services/get_streams.dart';
import 'package:chat_app/services/messages/send_message.dart';
import 'package:chat_app/services/user/retrive_userdata.dart';
import 'package:chat_app/widgets/message_textfeild.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final ChannelModel conversation;
  UserModel? otherUser;

  ChatPage({
    required this.conversation,
    this.otherUser,
  });

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
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100)).then((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
    return Consumer<MembershipProvider>(
      builder: (context, membershipProvider, child) {
        if (widget.conversation.image != null) {
          channelImage = widget.conversation.image!;
          channelName = widget.conversation.name!;
        } else {
          channelImage = widget.otherUser?.image;
          channelName = widget.otherUser?.name;
        }
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            elevation: 3,
            toolbarHeight: 60,
            backgroundColor: kPrimaryColor,
            title: Row(children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(channelImage!),
              ),
              const SizedBox(width: 10),
              Text(channelName!),
            ]),
          ),
          backgroundColor: kPrimaryColor,
          body: Column(
            children: [
              Expanded(
                flex: 100,
                child: StreamBuilder(
                  stream: getChannelStream(widget.conversation.uid),
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
                            String time;
                            BoxDecoration decoration;
                            CrossAxisAlignment alignment;
                            TextStyle style;
                            if (timeSent == null) {
                              time = 'Unknown';
                            } else {
                              var timeStamp = timeSent.toDate();
                              if (timeStamp.minute.toString().length == 1) {
                                time = timeStamp.hour.toString() +
                                    ":" +
                                    '0' +
                                    timeStamp.minute.toString();
                              } else {
                                time = timeStamp.hour.toString() +
                                    ":" +
                                    timeStamp.minute.toString();
                              }
                            }
                            if (snapshot.data.docs[index].data()['senderId'] ==
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (widget.conversation.type == 'grp' && snapshot.data.docs[index].data()['senderId'] != membershipProvider.user.uid)
                                        Text(
                                          snapshot.data.docs[index].data()['senderId'],),
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
                                    time,
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
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 2),
                      height: 40,
                      decoration: BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 7,
                              offset: Offset(0, 7))
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
                          sendMessage(message, widget.conversation,
                              membershipProvider.user);
                        }
                      }),
                      mini: true,
                      backgroundColor: kAccentColor,
                      child: const Icon(Icons.send),
                    )
                  ],
                ),
              ),
              // MessageTextFeildWidget(widget.conversation),
            ],
          ),
        );
      },
    );
  }
}
