import 'package:chat_app/constants.dart';
import 'package:chat_app/modals/chat_modals.dart';
import 'package:chat_app/modals/user_modals.dart';
import 'package:chat_app/providers/user.dart';
import 'package:chat_app/services/dm_conversations.dart';
import 'package:chat_app/services/get_modals.dart';
import 'package:chat_app/services/group_conversation.dart';
import 'package:chat_app/services/user/retrive_userdata.dart';
import 'package:chat_app/views/chat_page.dart';
import 'package:chat_app/views/create_group_chat_page.dart';
import 'package:chat_app/widgets/text_input_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  UserModel user;
  SearchPage({Key? key, required this.user}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool multiSelect = false;
  List<String> selectedUsers = [];
  final TextEditingController _searchController = TextEditingController();
  List<Map> searchList = [];
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<MembershipProvider>(
        builder: (context, membershipProvider, child) {
      return Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Start New Conversation",
            style: kHeadingTextStyle,
          ),
          backgroundColor: kPrimaryColor,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kAccentColor,
          onPressed: () async {
            var list =
                await membershipProvider.searchUsers(_searchController.text);
            setState(() {
              searchList = list;
            });
          },
          child: const Icon(
            Icons.add,
          ),
        ),
        body: Column(children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextInputContainer(
                    child: TextFormField(
                      decoration: kInputDecoration('Search People'),
                      controller: _searchController,
                    ),
                    icon: Icons.search,
                    trailing: GestureDetector(
                      onTap: () async {
                        if (selectedUsers.length >= 2) {
                          if (!selectedUsers.contains(membershipProvider.user.uid)) {
                            selectedUsers.add(membershipProvider.user.uid);
                          }
                          var grp = await getGroupConversation(selectedUsers);
                          if (grp == null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateGroupPage(
                                  users: selectedUsers,
                                ),
                              ),
                            );
                          } else {
                            var channelModel = await getChannelModel(grp);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  conversation: channelModel,
                                ),
                              ),
                            );
                          }
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: kAccentColor,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                        ),
                        child: const Icon(Icons.create),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (searchList.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: searchList.length,
                itemBuilder: (context, index) {
                  var uid = searchList[index]['uid'];
                  return ListTile(
                    selected: selectedUsers.contains(uid),
                    selectedColor: Colors.white,
                    selectedTileColor: kSecondaryColor,
                    onLongPress: () => setState(() {
                      multiSelect = true;
                      setState(() {
                          selectedUsers.add(uid);
                      });
                      print(multiSelect);
                    }),
                    onTap: () async {
                      if (multiSelect) {
                        setState(() {
                          if (!selectedUsers.contains(uid)) {
                            selectedUsers.add(uid);
                          } else {
                            selectedUsers.remove(uid);
                            if (selectedUsers.isEmpty) {
                              multiSelect = false;
                            }
                          }
                          print(selectedUsers);
                        });
                      } else {
                        String chatID = await getOrCreateDMConversation(
                            membershipProvider.user.uid, uid);
                        UserModel otherUser =
                            await getUserModel(uid);
                        ChannelModel channelModel =
                            await getChannelModel(chatID);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              conversation: channelModel,
                              otherUser : otherUser,
                            ),
                          ),
                        );
                      }
                    },
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(searchList[index]['displayPicture']),
                    ),
                    title: Text(
                      searchList[index]['displayName'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(searchList[index]['email'],
                        style: const TextStyle(color: Colors.white)),
                  );
                },
              ),
            ),
          if (_isSearching)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ]),
      );
    });
  }
}
