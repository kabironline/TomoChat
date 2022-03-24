import 'dart:io';

import 'package:TomoChat/constants.dart';
import 'package:TomoChat/modals/user_modals.dart';
import 'package:TomoChat/providers/user.dart';
import 'package:TomoChat/services/image_funcs.dart';
import 'package:TomoChat/widgets/action_button.dart';
import 'package:TomoChat/widgets/text_input_container.dart';
import 'package:TomoChat/widgets/user_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatefulWidget {
  UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool isEdited = false;
  File? image;

  String name = "";
  String description = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  void initState() {
    nameController.addListener(checkIfEdited);
    descriptionController.addListener(checkIfEdited);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MembershipProvider>(
      builder: (context, membershipProvider, child) {
        return Scaffold(
          backgroundColor: kPrimaryColor,
          appBar: AppBar(
            actions: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isEdited ? 1 : 0,
                child: IconButton(
                  onPressed: () {
                    //Reset the values of image, name and description
                    nameController.clear();
                    descriptionController.clear();
                    setState(() {
                      image = null;
                      isEdited = false;
                    });
                  },
                  icon: const Icon(Icons.restore),
                ),
              )
            ],
            elevation: 0,
            backgroundColor: kPrimaryColor,
            title: const Text('Profile'),
          ),
          body: Column(children: [
            _buildProfilePicture(membershipProvider.user),
            _buildUserDetails(membershipProvider.user),
            SizedBox(height: MediaQuery.of(context).size.height * 0.3),
            _buildSaveButton(membershipProvider),
          ]),
        );
      },
    );
  }

  Widget _buildProfilePicture(UserModel user) {
    return Center(
      child: Hero(
        tag: 'profile_picture',
        child: GestureDetector(
          onTap: () async {
            var file = await pickAvatarImage();
            if (file != null) {
              setState(() {
                isEdited = true;
                image = file;
              });
            }
          },
          child: profilePictureWidget(
            isFile: image == null ? null : true,
            imageSrc: image?.path ?? user.image,
            size: 150,
          ),
        ),
      ),
    );
  }

  Widget _buildUserDetails(UserModel user) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        children: [
          TextInputContainer(
            icon: Icons.person,
            child: TextFormField(
              controller: nameController,
              decoration: kInputDecoration(user.name),
            ),
          ),
          TextInputContainer(
            icon: Icons.description,
            child: TextFormField(
              controller: descriptionController,
              decoration: kInputDecoration(user.description ?? ""),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(MembershipProvider membershipProvider) {
    return AnimatedOpacity(
      opacity: isEdited ? 1 : 0,
      duration: Duration(milliseconds: 200),
      child: ActionButton(
        onPressed: () {
          if (isEdited) {
            membershipProvider.updateUser(
              nameController.text.isNotEmpty ? nameController.text : null,
              descriptionController.text.isNotEmpty
                  ? descriptionController.text
                  : null,
              image,
            );
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
          }
        },
        icon: Icons.check,
        text: "Save",
        color: isEdited ? kAccentColor : Colors.grey[700],
      ),
    );
  }

  void checkIfEdited() {
    var name = nameController.text;
    var description = descriptionController.text;
    if (image == null && (name.isEmpty) && (description.isEmpty)) {
      setState(() {
        isEdited = false;
      });
    } else {
      setState(() {
        isEdited = true;
      });
    }
  }
}
