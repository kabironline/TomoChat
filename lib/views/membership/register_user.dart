import 'dart:io';

import 'package:TomoChat/constants.dart';
import 'package:TomoChat/providers/user.dart';
import 'package:TomoChat/services/image_funcs.dart';
import 'package:TomoChat/utils/validation_builder.dart';
import 'package:TomoChat/views/home_page.dart';
import 'package:TomoChat/widgets/size_transition.dart';
import 'package:TomoChat/widgets/text_input_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterUserPage extends StatefulWidget {
  late String phoneNumber;
  late String uid;
  RegisterUserPage({Key? key, required this.phoneNumber, required this.uid}) : super(key: key);

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  late String name;
  String? imageURL;
  String? email;
  String? description;
  File? image;

  @override
  Widget build(BuildContext context) {
    return Consumer<MembershipProvider>(
      builder: (context, membership, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: kPrimaryColor,
          appBar: AppBar(
            elevation: 0,
            title: const Text('Register User'),
            backgroundColor: kPrimaryColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              children: [
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
                const SizedBox(height: kDefaultPadding),
                
                TextInputContainer(
                  icon: Icons.person,
                  child: TextFormField(
                    decoration: kInputDecoration('Username'),
                    validator: ValidationBuilder().maxLength(16).build(),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                ),
                TextInputContainer(
                  icon: Icons.alternate_email,
                  child: TextFormField(
                    decoration: kInputDecoration('Email'),
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: kDefaultPadding),
                TextInputContainer(
                  icon: Icons.description_sharp,
                  child: TextFormField(
                    decoration: kInputDecoration('Description'),
                    onChanged: (value) {
                      setState(() {
                        description = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                ElevatedButton(
                  child: const Text('Register'),
                  onPressed: () async {
                    //Upload image to Firebase Storage
                    if (image != null) {
                      imageURL = await uploadImage(
                        File(image!.path),
                        "users/${widget.uid}/profile_image",
                      );
                    }
                    await membership.registerUser(
                      name,
                      widget.uid,
                      widget.phoneNumber,
                      email,
                      description,
                      imageURL,
                    );
                    Navigator.pushReplacement(
                      context,
                      FadeRoute(
                        page: const HomePage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
