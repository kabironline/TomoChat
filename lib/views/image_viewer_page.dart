import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewerPage extends StatefulWidget {
  bool isFile;
  String heroTag;
  String imageSrc;
  ImageViewerPage({Key? key, this.isFile = false, this.heroTag = "", required this.imageSrc})
      : super(key: key);

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  PhotoViewController controller = PhotoViewController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Image"),
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0.2),
        elevation: 0,
      ),
      body: PhotoView(
        minScale: PhotoViewComputedScale.contained * 1,
        maxScale: PhotoViewComputedScale.contained * 1.5,
        controller: controller,
        heroAttributes: PhotoViewHeroAttributes(
          tag: widget.heroTag,
          transitionOnUserGestures: true,
        ),
        imageProvider: CachedNetworkImageProvider(
          widget.imageSrc,
        ),
      ),
    );
  }
}
