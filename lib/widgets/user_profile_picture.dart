import 'dart:io';

import 'package:TomoChat/constants.dart';
import 'package:flutter/material.dart';

class profilePictureWidget extends StatelessWidget {
  double size;
  String imageSrc;
  bool? isFile;
  bool? padding;

  profilePictureWidget({
    this.padding,
    this.isFile,
    required this.size,
    required this.imageSrc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(padding == null ? kDefaultPadding : 0),
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: kSecondaryColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 5,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: isFile != null
          ? isFile!
              ? Image.file(
                  File(imageSrc),
                  fit: BoxFit.fitHeight,
                )
              : const SizedBox()
          : Image.network(
              imageSrc,
              fit: BoxFit.fitHeight,
            ),
    );
  }
}
