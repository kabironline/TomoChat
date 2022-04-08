import 'dart:io';

import 'package:TomoChat/constants.dart';
import 'package:TomoChat/views/image_viewer_page.dart';
import 'package:TomoChat/widgets/size_transition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfilePictureWidget extends StatelessWidget {
  double size;
  String imageSrc;
  String heroTag;
  bool? isFile;
  bool padding;
  bool openImageViewer;

  ProfilePictureWidget({Key? key, 
    this.padding = false,
    this.isFile,
    this.openImageViewer = false,
    this.heroTag = "",
    required this.size,
    required this.imageSrc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (openImageViewer) {
      return GestureDetector(
        onTap: () {
          if (openImageViewer) {
            Navigator.push(
              context,
              FadeRoute(
                page: ImageViewerPage(
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
              : CachedNetworkImage(
                  imageUrl:imageSrc,
                  fit: BoxFit.fitHeight,
                  errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.white,),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                    value: downloadProgress.progress,
                    
                  ),
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
