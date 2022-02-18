import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  Function? onPressed;
  IconData icon;
  String text;
  Color? color;
  ActionButton({Key? key, required this.onPressed, required this.icon, required this.text, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(color ?? kSecondaryColor)),
      onPressed: () {onPressed?.call();},
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [Icon(icon,size: 24,), const SizedBox(width: 16), Text(text, style: kTextStyle,)],
        ),
      ),
    );
  }
}
