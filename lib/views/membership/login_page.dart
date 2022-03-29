import 'package:TomoChat/constants.dart';
import 'package:TomoChat/providers/user.dart';
import 'package:TomoChat/services/user/check_user_exists.dart';
import 'package:TomoChat/utils/validation_builder.dart';
import 'package:TomoChat/views/home_page.dart';
import 'package:TomoChat/views/membership/register_user.dart';
import 'package:TomoChat/widgets/action_button.dart';
import 'package:TomoChat/widgets/text_input_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String phoneNumber;
  late String otp;
  late String verificationId;
  bool otpSent = false;
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
            if (otpSent)
              TextInputContainer(
                icon: Icons.phone,
                child: TextFormField(
                  onChanged: (value) => setState(() {
                    otp = value;
                  }),
                  obscureText: true,
                  validator:
                      ValidationBuilder().minLength(10).valueRequired().build(),
                  keyboardType: TextInputType.number,
                  decoration: kInputDecoration("otp"),
                ),
              ),
            ActionButton(
              onPressed: () async {
                if (!otpSent) {
                  verifyNumber();
                } else {
                  verifyOTP();
                }
              },
              icon: Icons.phone_callback,
              text: (!otpSent ? "Send otp" : "Verify otp"),
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
          otpSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP() async {
    final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);
    UserCredential value = 
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (await checkUserExists(value.user!.uid)) {
      MembershipProvider membershipProvider = Provider.of<MembershipProvider>(context, listen: false);
      await membershipProvider.logInUser(value.user!.uid);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
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
