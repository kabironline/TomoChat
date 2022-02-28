import 'package:chat_app/modals/chat_modals.dart';
import 'package:chat_app/modals/user_modals.dart';
import 'package:chat_app/providers/user.dart';
import 'package:chat_app/services/get_streams.dart';
import 'package:chat_app/services/user/retrive_userdata.dart';
import 'package:chat_app/widgets/message_textfeild.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MembershipProvider>(
      builder: (context, membershipProvider, child){
        if (widget.conversation.image != null) {
          channelImage = widget.conversation.image!;
          channelName = widget.conversation.name!;
        } else {
            channelImage = widget.otherUser?.image;
            channelName = widget.otherUser?.name;
        }
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 60,
            title: Row(children: [
              CircleAvatar(
                backgroundImage: NetworkImage(channelImage!),
              ),
              const SizedBox(width: 10),
              Text(channelName!),
            ]),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: getChannelStream(widget.conversation.uid),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return const Text('Start New Converstation');
                    } else {
                      return SingleChildScrollView(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              DateTime timeStamp = snapshot.data.docs[index]
                                  .data()['time']
                                  .toDate();
                              String time;
                              BoxDecoration decoration;
                              CrossAxisAlignment alignment;
                              TextStyle style;
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
                              if (snapshot.data.docs[index]
                                      .data()['senderId'] ==
                                  membershipProvider.user.uid) {
                                alignment = CrossAxisAlignment.end;
                                decoration = const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(15),
                                  ),
                                );
                                style = const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                );
                              } else {
                                alignment = CrossAxisAlignment.start;
                                decoration = const BoxDecoration(
                                  color: Color(0xff5c5c5c),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(15),
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  ),
                                );
                                style = const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                );
                              }
                              return Column(
                                crossAxisAlignment: alignment,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.all(16),
                                    decoration: decoration,
                                    child: Text(
                                      snapshot.data.docs[index]['message'],
                                      style: style,
                                    ),
                                  ),
                                  Text(
                                    time,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                ),
              ),
              MessageTextFeildWidget(widget.conversation),
            ],
          ),
        );
      },
    );
  }
}
