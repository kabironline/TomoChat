import 'dart:io';

import 'package:TomoChat/constants.dart';
import 'package:TomoChat/views/image_viewer_page.dart';
import 'package:flutter/material.dart';

class profilePictureWidget extends StatelessWidget {
  double size;
  String imageSrc;
  String heroTag;
  bool? isFile;
  bool padding;
  bool openImageViewer;

  profilePictureWidget({
    this.padding = false,
    this.isFile,
    this.openImageViewer = false,
    this.heroTag = "",
    required this.size,
    required this.imageSrc,
  });

  @override
  Widget build(BuildContext context) {
    if (openImageViewer) {
      return GestureDetector(
        onTap: () {
          if (openImageViewer) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImageViewerPage(
                  isFile: isFile == null ? false : isFile!,
                  heroTag: heroTag,
                  imageSrc: imageSrc,
                ),
              ),
            );
          }
        },
        child: Container(
          margin: EdgeInsets.all(padding ? kDefaultPadding : 0),
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
        ),
      );
    }
    return Container(
      margin: EdgeInsets.all(padding ? kDefaultPadding : 0),
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
