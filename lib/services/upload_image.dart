import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

Future uploadImage(XFile image, String fileName) async {
  var ref = FirebaseStorage.instance.ref().child(fileName);
  var uploadTask = ref.putFile(File(image.path));
  var task = await uploadTask.whenComplete(() {});
  return await task.ref.getDownloadURL();
}
