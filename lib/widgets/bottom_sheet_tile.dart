import 'package:TomoChat/constants.dart';
import 'package:flutter/material.dart';

class BottomSheetTileWidget extends StatelessWidget {
  String text;
  IconData icon;
  Color? color;
  Function onTap;
  BottomSheetTileWidget({this.color, required this.text, required this.icon,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.all(kDefaultPaddingHalf),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          // color: kSecondaryColor,
        ),
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              size: 30,
              color: color,
            ),
            const SizedBox(
              width: kDefaultPadding,
            ),
            Text(
              text,
              style: kSubHeadingTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
