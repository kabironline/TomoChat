import 'dart:io';

import 'package:chat_app/constants.dart';
import 'package:chat_app/modals/chat_modals.dart';
import 'package:chat_app/providers/user.dart';
import 'package:chat_app/services/get_modals.dart';
import 'package:chat_app/services/group_conversation.dart';
import 'package:chat_app/services/upload_image.dart';
import 'package:chat_app/utils/validation_builder.dart';
import 'package:chat_app/views/group_chat_page.dart';
import 'package:chat_app/widgets/action_button.dart';
import 'package:chat_app/widgets/text_input_container.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateGroupPage extends StatefulWidget {
  late List<String> users;
  CreateGroupPage({required this.users});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  File? image;
  var picker = ImagePicker();
  String name = "";
  String description = "";
  @override
  Widget build(BuildContext context) {
    return Consumer<MembershipProvider>(
      builder: (context, membershipProvider, child) {
        return  Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        title: Text('Create Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(children: [
          GestureDetector(
            onTap: () async {
              var pickedImage =
                  await picker.pickImage(source: ImageSource.gallery);
              if (pickedImage == null) return;
              setState(() {
                image = File(pickedImage.path);
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: Container(
                color: kSecondaryColor,
                height: 150,
                width: 150,
                child: (image != null)
                    ? Image.file(image!)
                    : Image.asset('assets/images/group_default_image.png'),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.075),
          TextInputContainer(
            icon: Icons.people,
            child: TextFormField(
              onChanged: (value) => name = value,
              validator: ValidationBuilder().valueRequired().build(),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: kInputDecoration("Group Name"),
            ),
          ),
          SizedBox(height: 16),
          TextInputContainer(
            icon: Icons.people,
            child: TextFormField(
              onChanged: (value) => description = value,
              decoration: kInputDecoration("Description"),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.075),
          ActionButton(
            onPressed: () async {
              if (name == "") {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Group name is required'),
                ));
              }
              var uid = await createGroupConversation(widget.users, name, "", description);
              await updateGroupImage(image, uid);
              ChannelModel channel = await getChannelModel(uid);
              Navigator.push(context, MaterialPageRoute(builder: (context) => GroupChatPage(groupId: channel)));
            },
            icon: Icons.people_alt,
            text: "Create Group"
          ),
        ]),
      ),
    );
      },
    );
  }
}
