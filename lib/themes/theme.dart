import 'package:TomoChat/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// GethApplicationTheme is a function that returns a ThemeData
/// object. It is used to set the theme of the app.
ThemeData getApplicationTheme(BuildContext context) {
  return ThemeData.dark().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: kPrimaryColor,
    textTheme: _darkTextTheme,
    canvasColor: kSecondaryColor,
    iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    
  )
  );
}

final ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: kPrimaryColor,
  appBarTheme: AppBarTheme(
    color: kPrimaryColor,
    iconTheme: const IconThemeData(color: Colors.white),
  ),
  colorScheme: ColorScheme.dark(
    primary: kPrimaryColor,
    secondary: kSecondaryColor,
    onPrimary: Colors.white,
    background: kPrimaryColor,
  ),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  textTheme: _darkTextTheme,
  dividerTheme: const DividerThemeData(color: Colors.black),
);

final TextTheme _darkTextTheme = GoogleFonts.robotoTextTheme(
  ThemeData.dark().textTheme,
);
// TextTheme(
//   headline1: _darkScreenHeading1TextStyle,
// );

final TextStyle _lightScreenHeading1TextStyle = TextStyle(
    fontSize: 26.0, fontWeight: FontWeight.bold, color: kPrimaryColor, fontFamily: "Roboto");

final TextStyle _darkScreenHeading1TextStyle =
    _lightScreenHeading1TextStyle.copyWith(color: kPrimaryColor);
