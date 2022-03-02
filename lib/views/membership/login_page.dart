import 'dart:math';

import 'package:chat_app/constants.dart';
import 'package:chat_app/modals/user_modals.dart';
import 'package:chat_app/services/get_modals.dart';
import 'package:chat_app/services/user/check_user_exists.dart';
import 'package:chat_app/utils/validation_builder.dart';
import 'package:chat_app/views/home_page.dart';
import 'package:chat_app/views/membership/register_user.dart';
import 'package:chat_app/widgets/action_button.dart';
import 'package:chat_app/widgets/text_input_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String phoneNumber;
  late String OTP;
  late String verificationId;
  bool OTPSent = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Login Page',
                style: TextStyle(fontSize: 48),
              ),
            ),
            TextInputContainer(
              icon: Icons.phone,
              child: TextFormField(
                onChanged: (value) => setState(() {
                  phoneNumber = value;
                }),
                validator:
                    ValidationBuilder().minLength(10).valueRequired().build(),
                autovalidateMode: AutovalidateMode.always,
                keyboardType: TextInputType.phone,
                initialValue: "",
                decoration: kInputDecoration("+910123456789"),
              ),
            ),
            if (OTPSent)
              TextInputContainer(
                icon: Icons.phone,
                child: TextFormField(
                  onChanged: (value) => setState(() {
                    OTP = value;
                  }),
                  obscureText: true,
                  validator:
                      ValidationBuilder().minLength(10).valueRequired().build(),
                  keyboardType: TextInputType.number,
                  decoration: kInputDecoration("OTP"),
                ),
              ),
            ActionButton(
              onPressed: () async {
                if (!OTPSent) {
                  verifyNumber();
                } else {
                  verifyOTP();
                }
              },
              icon: Icons.phone_callback,
              text: (!OTPSent ? "Send OTP" : "Verify OTP"),
            ),
          ],
        ),
      ),
    );
  }

  void verifyNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      timeout: const Duration(seconds: 120),
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.code),
          ),
        );
      },
      codeSent: (String verificationId, int? resendToken) async {
        setState(() {
          this.verificationId = verificationId;
          OTPSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP() async {
    final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: OTP);
    UserCredential value =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (await checkUserExists(value.user!.uid)) {
      UserModel userDetails = await getUserModel(value.user!.uid);
      
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterUserPage(
            uid: value.user!.uid,
            phoneNumber: phoneNumber,
          ),
        ),
      );
    }
  }
}
