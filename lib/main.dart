import 'package:chat_app/modals/user_modals.dart';
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
import 'package:localstore/localstore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<Widget> userSignedIn() async {
    var user = await Localstore.instance.collection('user').get();
    if (user == null) {
      return LoginPage();
    } else {
      return HomePage(
          user: UserModel(
              name: user['name'],
              email: user['email'],
              uid: user['id'],
              date: user['createdAt'],
              image: user['displayPicture'],
              phoneNumber: user['phoneNumber']));
    }
    // User? user = FirebaseAuth.instance.currentUser;
    // if (user != null) {
    //   DocumentSnapshot userData = await FirebaseFirestore.instance
    //       .collection("users")
    //       .doc(user.uid)
    //       .get();
    // UserModel userModel = UserModel.fromDocument(userData);
    //   return HomePage(user: userModel);
    // } else {
    //   return LoginPage();
    // }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.signOut();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xff1D1D2A),
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          // bodyText1: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
          bodyText2: GoogleFonts.roboto(),
          subtitle1: GoogleFonts.roboto(
              textStyle: const TextStyle(color: Colors.white)),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xff5086B0),
          background: const Color(0xff1D1D2A),
        ),
      ),
      // home: TestPage(),
      home: FutureBuilder(
        future: signInWithPhone(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            Future.delayed(
                Duration(milliseconds: 500),
                (() => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          user: snapshot.data,
                        ),
                      ),
                    )));
          } else {
            return LoginPage();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
