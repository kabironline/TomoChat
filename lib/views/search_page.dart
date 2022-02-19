import 'package:chat_app/constants.dart';
import 'package:chat_app/modals/chat_modals.dart';
import 'package:chat_app/modals/user_modals.dart';
import 'package:chat_app/services/dm_conversations.dart';
import 'package:chat_app/services/get_modals.dart';
import 'package:chat_app/services/group_conversation.dart';
import 'package:chat_app/services/user/retrive_userdata.dart';
import 'package:chat_app/views/chat_page.dart';
import 'package:chat_app/widgets/text_input_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  void onSearch() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where("displayName", isEqualTo: _searchController.text)
        .get()
        .then((value) {
      setState(() {
        _isSearching = true;
      });
      if (value.docs.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No result found')));
        setState(() {
          _isSearching = false;
        });
        return;
      }
      value.docs.forEach((user) {
        if (user.data()['uid'] != widget.user.uid) {
          searchList.add(user.data());
        }
      });
      setState(() {
        _isSearching = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        elevation: 0,
        title: Text("Search",style: kHeadingTextStyle,),
        backgroundColor: kPrimaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          onSearch();
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
                padding: const EdgeInsets.all(10),
                child: TextInputContainer(
                  child: TextFormField(
                    decoration: kInputDecoration('Search People'),
                    controller: _searchController,
                  ),
                  icon: Icons.search,
                  trailing: GestureDetector(
                    onTap: () async {
                      if (selectedUsers.length >= 2) {
                        selectedUsers.add(widget.user.uid);
                        var grp = await getOrCreateGroupConversation(selectedUsers);
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: kAccentColor,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
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
                  onLongPress: () => setState(() {
                    multiSelect = true;
                    selectedUsers.add(uid);
                    print(multiSelect);
                  }),
                  onTap: () async {
                    if (multiSelect) {
                      if (!selectedUsers.contains(uid)) {
                        selectedUsers.add(uid);
                      } else {
                        selectedUsers.remove(uid);
                      }
                      print(selectedUsers);
                    } else {
                      String chatID =
                          await getOrCreateDMConversation(widget.user.uid, uid);
                      UserModel otherUser =
                          await getDMOtherUser(chatID, widget.user.uid);
                      ChannelModel channelModel =
                          await getChannelModel(chatID);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            conversation: channelModel,
                            currentUser: widget.user,
                            otherUser: otherUser,
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
  }
}
