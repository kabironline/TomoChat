import 'package:chat_app/modals/user_modals.dart';
import 'package:chat_app/services/user/check_user_exists.dart';
import 'package:chat_app/services/user/user_sign_in.dart';
import 'package:chat_app/views/membership/register_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../home_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: const Text(
                'Login Page',
                style: TextStyle(fontSize: 48),
              ),
            ),
            FutureBuilder(
                future: signInWithPhone(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    print(snapshot.data);
                  }
                  return Container();
                })
          ],
        ),
      ),
    );
  }
}
