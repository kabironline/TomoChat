import 'package:TomoChat/constants.dart';
import 'package:TomoChat/providers/channel.dart';
import 'package:TomoChat/providers/user.dart';
import 'package:TomoChat/services/get_streams.dart';
import 'package:TomoChat/utils/timestamp_converter.dart';
import 'package:TomoChat/views/chat/chat_detail_page.dart';
import 'package:TomoChat/views/image_viewer_page.dart';
import 'package:TomoChat/widgets/message_bottom_sheet.dart';
import 'package:TomoChat/widgets/user_profile_picture.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String? channelImage;
  String? channelName;
  TextEditingController chatBoxTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int messageCount = 20;
  var height = 40.0;
  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        setState(() {
          messageCount += 20;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MembershipProvider>(
      builder: (context, membershipProvider, child) {
        return Consumer<ChannelProvider>(builder: (context, channelProvider, child) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              elevation: 3,
              toolbarHeight: 60,
              backgroundColor: kPrimaryColor,
              title: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatDetailPage(),
                    ),
                  );
                },
                child: Row(children: [
                  Hero(
                    tag: "${channelProvider.channel!.uid}-image",
                    child: ProfilePictureWidget(
                      padding: true,
                      size: 50,
                      imageSrc: channelProvider.channelImage!,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    channelProvider.channelName!,
                    style: kSubHeadingTextStyle,
                  ),
                ]),
              ),
            ),
            backgroundColor: kPrimaryColor,
            body: Column(
              children: [
                const SizedBox(height: kDefaultPaddingHalf),
                buildMessageStream(
                  context,
                  channelProvider,
                  membershipProvider,
                ),
                buildTextField(context, channelProvider)
              ],
            ),
          );
        });
      },
    );
  }

  Widget buildMessageStream(BuildContext context, ChannelProvider channelProvider,
      MembershipProvider membershipProvider) {
    return Expanded(
      child: StreamBuilder(
        stream: getChannelStream(channelProvider.channel!.uid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text('Start New Converstation'));
          } else {
            messageCount =
                messageCount > snapshot.data.docs.length ? snapshot.data.docs.length : messageCount;
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.75,
              child: ListView.builder(
                reverse: true,
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: messageCount,
                itemBuilder: (BuildContext context, int index) {
                  var timeSent = snapshot.data.docs[index].data()['time'];
                  var msgType = snapshot.data.docs[index].data()['type'];
                  var displayTime = true;
                  var displayName = true;
                  var currentMessageSender = snapshot.data.docs[index].data()['senderId'];
                  String? link;
                  var links;
                  try {
                    link = snapshot.data.docs[index]['firstLink'];
                    links = snapshot.data.docs[index]['links'];
                  } catch (e) {
                    // link = null;
                    //Doing nothing cause both value will be null either way
                  }
                  BoxDecoration decoration;
                  //Checking if the text contians a link and finding out the link
                  String message = snapshot.data.docs[index].data()['message'] ?? "";

                  CrossAxisAlignment alignment;
                  if (currentMessageSender == membershipProvider.user.uid) {
                    alignment = CrossAxisAlignment.end;
                    decoration = kSelfMessageBoxDecoration;
                  } else {
                    alignment = CrossAxisAlignment.start;
                    decoration = kOtherMessageBoxDecoration;
                  }
                  if (index != snapshot.data.docs.length - 1 && index != 0) {
                    var nextMessageTime = snapshot.data.docs[index + 1].data()['time'];
                    var nextMessageSender =
                        snapshot.data.docs[index + 1].data()['senderId'] == currentMessageSender;
                    var prevMessageSender =
                        snapshot.data.docs[index - 1].data()['senderId'] == currentMessageSender;
                    if (nextMessageTime == null) {
                      displayTime = false;
                    } else if (convertTimeStamp(timeSent) == convertTimeStamp(nextMessageTime) &&
                        nextMessageSender) {
                      displayTime = false;
                    }
                    if (prevMessageSender && nextMessageSender) {
                      displayName = false;
                    }
                  }
                  return Column(
                    crossAxisAlignment: alignment,
                    children: [
                      GestureDetector(
                        onLongPress: () {
                          messageBottomSheet(
                            context,
                            channelProvider,
                            snapshot.data.docs[index].reference,
                            message,
                            channelProvider.currentUser!.uid == currentMessageSender,
                            links,
                          );
                        },
                        onTap: () {
                          if (msgType == "media") {
                            return;
                          } else if (links == null) {
                            return;
                          } else if (links.length > 1) {
                            messageBottomSheet(
                              context,
                              channelProvider,
                              snapshot.data.docs[index].reference,
                              message,
                              channelProvider.currentUser!.uid == currentMessageSender,
                              links,
                            );
                          } else {
                            launch(message);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: displayTime ? 0 : 0,
                            bottom: displayTime ? 8 : 2,
                          ),
                          decoration: decoration,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (channelProvider.channel!.type == 'grp' &&
                                  currentMessageSender != membershipProvider.user.uid &&
                                  displayName)
                                Text(channelProvider.grpUsers[currentMessageSender]!.name,
                                    style: kSubTextStyle),
                              if (msgType == 'text')
                                Text(
                                  message,
                                  style: kSubHeadingTextStyle,
                                ),
                              if (msgType == 'media')
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ImageViewerPage(
                                            imageSrc: link!,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Image.network(message)),
                              if (msgType == 'link' || msgType == 'text-link')
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (message.trim().isNotEmpty)
                                      Text(
                                        message,
                                        style: kSubHeadingTextStyle,
                                      ),
                                    const SizedBox(height: kDefaultPaddingHalf),
                                    AnyLinkPreview(
                                      errorWidget: const SizedBox(),
                                      // errorImage: "",
                                      errorBody: "Unable to fetch Image",
                                      // placeholderWidget: Center(child: Text("Loading...", style: kHeadingTextStyle)),
                                      removeElevation: true,
                                      displayDirection: uiDirection.uiDirectionHorizontal,
                                      titleStyle: kHeadingTextStyle,
                                      bodyStyle: kSubTextStyle,
                                      backgroundColor: kSecondaryColor,
                                      link: link!,
                                      showMultimedia: true,
                                      cache: const Duration(days: 7),
                                    ),
                                  ],
                                )
                            ],
                          ),
                        ),
                      ),
                      if (displayTime)
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                          child: Text(
                            timeSent == null ? "" : convertTimeStamp(timeSent),
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
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
    );
  }

  Widget buildTextField(BuildContext context, ChannelProvider channelProvider) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 2),
            // height: height.toDouble(),
            constraints: const BoxConstraints(maxHeight: 150, minHeight: 40),
            decoration: BoxDecoration(
              color: kSecondaryColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 7,
                  offset: Offset(0, 7),
                )
              ],
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 120,
              child: TextField(
                controller: chatBoxTextController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  errorMaxLines: 0,
                  border: InputBorder.none,
                  isDense: true,
                  hintText: 'Type a message',
                ),
              ),
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
