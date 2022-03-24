import 'dart:io';

import 'package:TomoChat/constants.dart';
import 'package:TomoChat/providers/channel.dart';
import 'package:TomoChat/providers/user.dart';
import 'package:TomoChat/services/image_funcs.dart';
import 'package:TomoChat/utils/validation_builder.dart';
import 'package:TomoChat/views/chat/chat_page.dart';
import 'package:TomoChat/widgets/action_button.dart';
import 'package:TomoChat/widgets/text_input_container.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateGroupPage extends StatefulWidget {
  late List<String> users;
  CreateGroupPage({Key? key, required this.users}) : super(key: key);

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
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: kPrimaryColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: kPrimaryColor,
            title: const Text('Create Group'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(children: [
              GestureDetector(
                onTap: () async {
                  var temp = await pickAvatarImage();
                  setState(() {
                    image = temp;
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
              const SizedBox(height: 16),
              TextInputContainer(
                icon: Icons.people,
                child: TextFormField(
                  onChanged: (value) => description = value,
                  decoration: kInputDecoration("Description"),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.075),
              Consumer<ChannelProvider>(
                builder: (context, channelProvider, child) {
                  return ActionButton(
                    onPressed: () async {
                      if (name == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Group name is required'),
                          ),
                        );
                      }
                      channelProvider.setCurrentUser(membershipProvider.user);
                      var channel = await channelProvider.createGrpChannel(
                          widget.users, name, description, image);
                      await channelProvider.setChannel(channel.uid, null, name);
                      Navigator.popAndPushNamed(context, '/chat');
                    },
                    icon: Icons.people_alt,
                    text: "Create Group",
                  );
                },
              ),
            ]),
          ),
        );
      },
    );
  }
}
