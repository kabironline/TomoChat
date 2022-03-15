import 'package:TomoChat/constants.dart';
import 'package:flutter/material.dart';

class profilePictureWidget extends StatelessWidget {
  double size;
  String imageSrc;
  bool? padding;

  profilePictureWidget(
      {this.padding,required this.size, required this.imageSrc} );
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(padding == null ? kDefaultPadding : 0),
      width: size,
      height: size,
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
        image: DecorationImage(
          fit: BoxFit.fitHeight,
          image: NetworkImage(imageSrc),
        ),
      ),
    );
  }
}
