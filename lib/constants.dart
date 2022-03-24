import 'package:flutter/material.dart';

Color kPrimaryColor = const Color(0xff1D1D2A);
Color kSecondaryColor = const Color(0xff3E3E58);
Color kIconColor = const Color(0xff67677F);
Color kAccentColor = const Color(0xff007BDB);

// Color kPrimaryColor = Color.fromARGB(255, 255, 255, 255);
// Color kSecondaryColor = Color.fromARGB(255, 223, 223, 223);
// Color kAccentColor = const Color(0xff007BDB);

const String kdefualtUserProfilePicture =
    'https://firebasestorage.googleapis.com/v0/b/chat-app-test-84888.appspot.com/o/default%20profile%20picture.jpg?alt=media&token=bbcc2a67-b153-4944-a627-c214b0812834';

const String kDefualtGroupProfilePicture =
    "https://firebasestorage.googleapis.com/v0/b/chat-app-test-84888.appspot.com/o/group_default_image.png?alt=media&token=f3f0180b-6f51-424a-9d5d-be7e8cfe3ff4";

const double kDefaultPadding = 16.0;
const double kDefaultPaddingHalf = 8.0;

TextStyle kHeadingTextStyle = const TextStyle(
  fontSize: 20,
  color: Colors.white,
  fontWeight: FontWeight.bold,
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

BoxDecoration kAvatarBoxDecoration = BoxDecoration(
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.25),
      blurRadius: 10,
      offset: const Offset(0, 5),
    ),
  ],
  borderRadius: BorderRadius.circular(50),
);

BoxDecoration kSelfMessageBoxDecoration = const BoxDecoration(
  color: Color(0xff606082),
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(7),
    bottomLeft: Radius.circular(7),
    topRight: Radius.circular(2),
    bottomRight: Radius.circular(7),
  ),
  boxShadow: [
    BoxShadow(color: Colors.black12, blurRadius: 7, offset: Offset(0, 7))
  ],
);

BoxDecoration kOtherMessageBoxDecoration = const BoxDecoration(
  color: Color(0xff3B3B51),
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(2),
    bottomLeft: Radius.circular(7),
    topRight: Radius.circular(7),
    bottomRight: Radius.circular(7),
  ),
  boxShadow: [
    BoxShadow(color: Colors.black12, blurRadius: 7, offset: Offset(0, 7))
  ],
);

InputDecoration kInputDecoration(String hintText) {
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
