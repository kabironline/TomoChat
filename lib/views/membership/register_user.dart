import 'package:chat_app/services/upload_image.dart';
import 'package:chat_app/services/user/register_user.dart';
import 'package:chat_app/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterUserPage extends StatefulWidget {
  late String phoneNumber;
  late String uid;
  RegisterUserPage({required this.phoneNumber, required this.uid});

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  late String name;
  String? email;
  String? imageURL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register User'),
      ),
      body: Column(
        children: [
          const Text('Register User'),
          GestureDetector(
            onTap: () {
              //Use ImagePicker to get image from camera or gallery
              ImagePicker()
                  .pickImage(source: ImageSource.gallery)
                  .then((image) async {
                if (image != null) {
                  setState(() async {
                    //Uploading selected image to firebase storage
                    imageURL = await uploadImage(
                        image, 'users/${widget.uid}/profile_image');
                  });
                }
              });
            },
            child: Container(
              height: 150,
              width: 150,
              color: Colors.white,
              //Create Image picker that picks and crops images to 1:1 ratio and uploads them to the Firebase Storage
              child: Image.network(imageURL ??
                  'https://firebasestorage.googleapis.com/v0/b/chat-app-test-84888.appspot.com/o/default%20profile%20picture.jpg?alt=media&token=bbcc2a67-b153-4944-a627-c214b0812834'),
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
              var user = await registerUser(
                  name, email, widget.phoneNumber, widget.uid, imageURL);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (conext) => HomePage(user: user),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
