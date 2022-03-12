import 'package:flutter/material.dart';

class BottomSheetTile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Ink(child: InkWell(onTap : () {}, child: Container(
      height: 50,
      child: Center(child: Text('Bottom Sheet')),
    ),),);
  }
}