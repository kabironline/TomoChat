import 'dart:io';

import 'package:TomoChat/constants.dart';
import 'package:TomoChat/services/image_funcs.dart';
import 'package:TomoChat/utils/validation_builder.dart';
import 'package:TomoChat/widgets/text_input_container.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  File? image;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    var imagePicker = ImagePicker();
                    imagePicker
                        .pickImage(
                            source: ImageSource.gallery, imageQuality: 70)
                        .then((value) async {
                      File? tempVal;
                      tempVal =
                          value!.path.isNotEmpty ? File(value.path) : null;
                      tempVal = value.path.isNotEmpty
                          ? await cropImage(tempVal!)
                          : null;
                      setState(() {
                        image = tempVal;
                      });
                    });
                    if (image != null) {
                      // compressImage(image!);
                    }
                  },
                  child: Container(
                    height: 350,
                    width: 350,
                    color: Colors.black,
                    child: image != null
                        ? Image.file(image!, fit: BoxFit.cover)
                        : Text(
                            'No image',
                            style: kHeadingTextStyle,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
