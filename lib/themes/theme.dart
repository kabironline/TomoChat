import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// GethApplicationTheme is a function that returns a ThemeData
/// object. It is used to set the theme of the app.
ThemeData getApplicationTheme(BuildContext context) {
  return ThemeData.dark().copyWith(
    primaryColor: kPrimaryColor,
    textTheme: GoogleFonts.robotoTextTheme(
      Theme.of(context).textTheme,
    ).copyWith(
      // bodyText1: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
      bodyText2: GoogleFonts.roboto(),
      subtitle1:
          GoogleFonts.roboto(textStyle: const TextStyle(color: Colors.white)),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: kSecondaryColor,
      background: kPrimaryColor,
    ),
  );
}
