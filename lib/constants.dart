import 'package:flutter/material.dart';

Color kPrimaryColor = const Color(0xff1D1D2A);
Color kSecondaryColor = const Color(0xff3E3E58);
Color kAccentColor = const Color(0xff007BDB);

// Color kPrimaryColor = Color.fromARGB(255, 255, 255, 255);
// Color kSecondaryColor = Color.fromARGB(255, 223, 223, 223);
// Color kAccentColor = const Color(0xff007BDB);

TextStyle kHeadingTextStyle = const TextStyle(
  fontSize: 20,
  color: Colors.white,
  fontWeight: FontWeight.w500,
);

TextStyle kSubHeadingTextStyle = const TextStyle(
  fontSize: 18,
  color: Colors.white,
  // fontWeight: FontWeight.bold,
);
TextStyle kTextStyle = const TextStyle(
  fontSize: 16,
  color: Colors.white,
);

TextStyle kSubTextStyle = const TextStyle(
  fontSize: 14,
  color: Colors.white,
);

InputDecoration kInputDecoration (String hintText) {
  return InputDecoration(
    hintText: hintText,
    labelStyle: const TextStyle(
      fontSize: 20,
    ),
    hintStyle: const TextStyle(
      fontSize: 20,
    ),
    border: InputBorder.none,
  );
}