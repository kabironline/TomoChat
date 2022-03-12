import 'package:TomoChat/constants.dart';
import 'package:TomoChat/modals/user_modals.dart';
import 'package:TomoChat/providers/channel.dart';
import 'package:TomoChat/providers/user.dart';
import 'package:TomoChat/views/chat/chat_page.dart';
import 'package:TomoChat/views/chat/create_group_chat_page.dart';
import 'package:TomoChat/widgets/text_input_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool multiSelect = false;
  List<String> selectedUsers = [];
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> searchList = [];
  List<String> searchListUid = [];
  bool searchDone = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<MembershipProvider>(
        builder: (context, membershipProvider, child) {
      return FutureBuilder(
          future: membershipProvider.getUsersContacts(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            Future.delayed(const Duration(milliseconds: 00), () {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              setState(() {
                if (snapshot.hasData &&
                    !searchDone &&
                    snapshot.connectionState == ConnectionState.done) {
                  searchList = snapshot.data;
                  for (String uid in snapshot.data.uid) {
                    searchListUid.add(uid);
                  }
                  searchDone = true;
                }
              });
            });
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
                  var list = await membershipProvider
                      .searchUsers(_searchController.text);
                  setState(() {
                    for (var user in list!) {
                      if (!searchListUid.contains(user.uid)) {
                        searchList.add(user);
                        searchListUid.add(user.uid);
                      }
                    }
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
                                if (!selectedUsers
                                    .contains(membershipProvider.user.uid)) {
                                  selectedUsers
                                      .add(membershipProvider.user.uid);
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateGroupPage(
                                      users: selectedUsers,
                                    ),
                                  ),
                                );
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
                    flex: 100,
                    child: ListView.builder(
                      itemCount: searchList.length,
                      itemBuilder: (context, index) {
                        var uid = searchList[index].uid;
                        return ListTile(
                          selected: selectedUsers.contains(uid),
                          selectedColor: Colors.white,
                          selectedTileColor: kSecondaryColor,
                          onLongPress: () => setState(() {
                            multiSelect = true;
                            setState(() {
                              selectedUsers.add(uid);
                            });
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
                              });
                            } else {
                              ChannelProvider channelProvider =
                                  Provider.of<ChannelProvider>(context,
                                      listen: false);
                              channelProvider
                                  .setCurrentUser(membershipProvider.user);
                              await channelProvider.checkDMChannel(uid);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ChatPage(),
                                ),
                              );
                            }
                          },
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(searchList[index].image),
                          ),
                          title: Text(
                            searchList[index].name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(searchList[index].phoneNumber,
                              style: const TextStyle(color: Colors.white)),
                        );
                      },
                    ),
                  ),
              ]),
            );
          });
    });
  }
}
