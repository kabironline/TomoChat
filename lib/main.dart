import 'package:chat_app/constants.dart';
import 'package:chat_app/modals/user_modals.dart';
import 'package:chat_app/services/get_modals.dart';
import 'package:chat_app/services/user/register_user.dart';
import 'package:chat_app/services/user/user_sign_in.dart';
import 'package:chat_app/views/home_page.dart';
import 'package:chat_app/views/membership/login_page.dart';
import 'package:chat_app/views/membership/register_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<Widget?> userSignedIn() async {
    var prefs = await SharedPreferences.getInstance();
    var user = await prefs.getStringList('user');
    if (user == null) {
      var userFirebase = await signInWithPhone();
      if (userFirebase == null) {
        return LoginPage();
      }
      return HomePage(user: userFirebase);
    } else {
      return HomePage(user: await getUserModel(user));
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.signOut();
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   primaryColor: kPrimaryColor,
      //   backgroundColor: kSecondaryColor,
      //   textTheme: GoogleFonts.robotoTextTheme(),
      // ),
      theme: ThemeData.dark().copyWith(
        primaryColor: kPrimaryColor,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          // bodyText1: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
          bodyText2: GoogleFonts.roboto(),
          subtitle1: GoogleFonts.roboto(
              textStyle: const TextStyle(color: Colors.white)),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: kSecondaryColor,
          background: kPrimaryColor,
        ),
      ),
      // home: TestPage(),
      home: FutureBuilder(
        future: userSignedIn(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => snapshot.data,
                ),
              );
            });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
