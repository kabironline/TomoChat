import 'dart:io';

import 'package:TomoChat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<String> uploadImage(File image, String fileName) async {
  var ref = FirebaseStorage.instance.ref().child(fileName);
  var uploadTask = ref.putFile(image);
  var task = await uploadTask.whenComplete(() {});
  return await task.ref.getDownloadURL();
}

Future<CroppedFile?> cropImage(File image) async {
  return await ImageCropper().cropImage(
    sourcePath: image.path,
    aspectRatio: const CropAspectRatio(
      ratioX: 1,
      ratioY: 1,
    ),
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Crop Image for Profile',
        toolbarColor: kPrimaryColor,
        toolbarWidgetColor: Colors.white,
        statusBarColor: kPrimaryColor,
        backgroundColor: kPrimaryColor,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true,
      )
    ],
  );
}

Future<File?> pickAvatarImage() async {
  var image = await ImagePicker()
      .pickImage(source: ImageSource.gallery, imageQuality: 40);
  if (image == null) return null;
  File? croppedImage = (await cropImage(File(image.path))) as File?;
  if (croppedImage == null) return null;
  return croppedImage;
}

Future updateGroupImage(File? image, String uid, String recentChatId) async {
  String? url;
  if (image != null) {
    url = await uploadImage(image, 'group/$uid/profile');
  }
  //Checking if the image is not starting with http, then it is a firebase url

  if (image?.path == "" ||
      image == null ||
      !url!.startsWith('https://firebasestorage.googleapis.com/v0/b/')) {
    url = kDefualtGroupProfilePicture;
  }

  await FirebaseFirestore.instance
      .collection('channels')
      .doc(uid)
      .update({'image': url});
  await FirebaseFirestore.instance
      .collection('recentChat')
      .doc(recentChatId)
      .update({'image': url});
  return url;
}
