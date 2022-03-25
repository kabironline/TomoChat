import 'package:TomoChat/constants.dart';
import 'package:TomoChat/modals/user_modals.dart';
import 'package:TomoChat/providers/channel.dart';
import 'package:TomoChat/providers/user.dart';
import 'package:TomoChat/views/chat/chat_page.dart';
import 'package:TomoChat/views/chat/create_group_chat_page.dart';
import 'package:TomoChat/widgets/text_input_container.dart';
import 'package:TomoChat/widgets/user_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  bool? isUserSelect;
  ChannelProvider? channelProvider;
  SearchPage({Key? key, this.isUserSelect, this.channelProvider})
      : super(key: key);
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
            if (snapshot.hasData &&
                !searchDone &&
                snapshot.connectionState == ConnectionState.done) {
              searchList = snapshot.data;
              if (searchList.isNotEmpty) {
                for (var element in searchList) {
                  searchListUid.add(element.uid);
                }
              }
              searchDone = true;
            }
            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: kPrimaryColor,
              appBar: AppBar(
                elevation: 0,
                toolbarHeight: 60,
                title: Text(
                  "Search Contacts",
                  style: kHeadingTextStyle,
                ),
                backgroundColor: kPrimaryColor,
              ),
              floatingActionButton:
                  _buildFloatingActionButton(context, membershipProvider),
              body: Column(
                children: [
                  _buildSearchBar(context, membershipProvider),
                  searchDone
                      ? _buildSearchList(
                          context, searchList, membershipProvider)
                      : const Center(child: CircularProgressIndicator()),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget? _buildFloatingActionButton(
      BuildContext context, MembershipProvider membershipProvider) {
    if (selectedUsers.isNotEmpty && widget.isUserSelect == null) {
      return FloatingActionButton(
        backgroundColor: kAccentColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          if (!selectedUsers.contains(membershipProvider.user.uid)) {
            selectedUsers.add(membershipProvider.user.uid);
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateGroupPage(
                users: selectedUsers,
              ),
            ),
          );
        },
      );
    } else if (selectedUsers.isNotEmpty && widget.isUserSelect == true) {
      return FloatingActionButton(
        backgroundColor: kAccentColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          await widget.channelProvider!.addUserToChannel(selectedUsers);
          Navigator.pop(context, selectedUsers);
        },
      );
    } else {
      return null;
    }
  }

  Widget _buildSearchBar(
      BuildContext context, MembershipProvider membershipProvider) {
    return SizedBox(
      height: 90,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextInputContainer(
                child: TextFormField(
                  onChanged: (value) {
                    //Searching users in the list
                    setState(() {
                      searchList =
                          membershipProvider.contacts!.where((element) {
                        return element.name
                            .toLowerCase()
                            .contains(value.toLowerCase());
                      }).toList();
                    });
                  },
                  decoration: kInputDecoration('Search People'),
                  controller: _searchController,
                ),
                icon: Icons.search,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //TODO MAKE THE LIST ITEM A SEPERATE WIDGET AND THEN USE IF EVERYWHERE
  Widget _buildSearchList(BuildContext context, List<UserModel> searchList,
      MembershipProvider membershipProvider) {
    return RefreshIndicator(
      backgroundColor: kAccentColor,
      color: Colors.white,
      onRefresh: () async {
        searchDone = false;
        searchList = (await membershipProvider.refreshContacts()) ?? [];
        setState(() {
          membershipProvider.refreshContacts();
          if (searchList.isNotEmpty) {
            for (var element in searchList) {
              searchListUid.add(element.uid);
            }
          }
          searchDone = true;
        });
      },
      child: Container(
        // flex: 100,
        height: MediaQuery.of(context).size.height - 174,
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
                if (multiSelect || widget.isUserSelect != null) {
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
                      Provider.of<ChannelProvider>(context, listen: false);
                  channelProvider.setCurrentUser(membershipProvider.user);
                  await channelProvider.checkDMChannel(uid);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatPage(),
                    ),
                  );
                }
              },
              leading: Hero(
                tag: searchList[index].uid,
                child: profilePictureWidget(
                  openImageViewer: true,
                  heroTag: searchList[index].uid,
                  size: 50,
                  padding: false,
                  imageSrc: searchList[index].image,
                ),
              ),
              title: Text(
                searchList[index].name,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                searchList[index].phoneNumber,
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}
