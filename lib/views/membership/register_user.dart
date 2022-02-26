import 'dart:io';

import 'package:chat_app/providers/user.dart';
import 'package:chat_app/services/upload_image.dart';
import 'package:chat_app/services/user/register_user.dart';
import 'package:chat_app/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RegisterUserPage extends StatefulWidget {
  late String phoneNumber;
  late String uid;
  RegisterUserPage({required this.phoneNumber, required this.uid});

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  late String name;
  String? imageURL;
  String? email;
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Consumer<MembershipProvider>(builder: (context, membership, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Register User'),
        ),
        body: Column(
          children: [
            const Text('Register User'),
            GestureDetector(
              onTap: () async {
                //Use ImagePicker to get image from camera or gallery
                image =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
              },
              child: Container(
                height: 150,
                width: 150,
                color: Colors.white,
                //Create Image picker that picks and crops images to 1:1 ratio and uploads them to the Firebase Storage
                child: image == null
                    ? Image.asset(name)
                    : Image.file(File(image!.path)),
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Username'),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            ElevatedButton(
              child: const Text('Register'),
              onPressed: () async {
                //Upload image to Firebase Storage
                if (image != null) {
                  imageURL = await uploadImage(File(image!.path), "");
                }
                await membership.registerUser(
                    name, widget.uid, widget.phoneNumber, email, imageURL);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (conext) => const HomePage(),
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
