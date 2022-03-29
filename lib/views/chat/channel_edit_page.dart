import 'dart:io';

import 'package:TomoChat/constants.dart';
import 'package:TomoChat/providers/channel.dart';
import 'package:TomoChat/services/image_funcs.dart';
import 'package:TomoChat/utils/validation_builder.dart';
import 'package:TomoChat/widgets/action_button.dart';
import 'package:TomoChat/widgets/text_input_container.dart';
import 'package:TomoChat/widgets/user_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatEditPage extends StatefulWidget {
  const ChatEditPage({Key? key}) : super(key: key);

  @override
  State<ChatEditPage> createState() => _ChatEditPageState();
}

class _ChatEditPageState extends State<ChatEditPage> {
  File? image;
  String name = "";
  String description = "";
  bool isEdited = false;
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
    ChannelProvider channelProvider =
        Provider.of<ChannelProvider>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        actions: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isEdited ? 1 : 0,
            child: IconButton(
              onPressed: () {
                //Reset the values of image, name and description
                setState(() {
                  image = null;
                  name = channelProvider.channelName!;
                  description = channelProvider.channel!.description!;
                  isEdited = false;
                });
              },
              icon: const Icon(Icons.restore),
            ),
          )
        ],
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: const Text("Edit Channel"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                var pickedImage = await pickAvatarImage();
                if (pickedImage != null) {
                  setState(() {
                    isEdited = true;
                    image = pickedImage;
                  });
                }
              },
              child: Hero(
                tag: "${channelProvider.channel!.uid}-image",
                child: ProfilePictureWidget(
                  size: 150,
                  imageSrc: image == null
                      ? channelProvider.channelImage!
                      : image!.path,
                  isFile: image == null ? null : true,
                ),
              ),
            ),
            TextInputContainer(
              icon: Icons.group,
              child: TextFormField(
                controller: nameController,
                decoration: kInputDecoration(channelProvider.channelName!),
              ),
            ),
            TextInputContainer(
              icon: Icons.description,
              child: TextFormField(
                controller: descriptionController,
                validator: ValidationBuilder().maxLength(32).build(),
                autovalidateMode: AutovalidateMode.always,
                decoration:
                    kInputDecoration(channelProvider.channel!.description!),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.3),
            ActionButton(
              onPressed: () {
                if (isEdited) {
                  channelProvider.updateChannel(
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
          ],
        ),
      ),
    );
  }

  void checkIfEdited() {
    ChannelProvider channelProvider =
        Provider.of<ChannelProvider>(context, listen: false);
    var name = nameController.text;
    var description = descriptionController.text;
    if (image == null &&
        (name == channelProvider.channelName! || name.isEmpty) &&
        (description == channelProvider.channel!.description ||
            description.isEmpty)) {
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
