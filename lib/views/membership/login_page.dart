import 'package:TomoChat/constants.dart';
import 'package:TomoChat/providers/user.dart';
import 'package:TomoChat/services/user/check_user_exists.dart';
import 'package:TomoChat/utils/validation_builder.dart';
import 'package:TomoChat/views/home_page.dart';
import 'package:TomoChat/views/membership/register_user.dart';
import 'package:TomoChat/widgets/action_button.dart';
import 'package:TomoChat/widgets/size_transition.dart';
import 'package:TomoChat/widgets/text_input_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
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
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kPrimaryColor,
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.15),
            SizedBox(height: 150, width: 150, child: Image.asset('assets/images/logo.png')),
            const Text(
              "TomoChat",
              style: TextStyle(fontSize: 36),
            ),
            SizedBox(height: screenHeight * 0.15),
            Container(
              decoration:
                  BoxDecoration(color: kSecondaryColor, borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddingHalf),
              child: InternationalPhoneNumberInput(
                onInputChanged: (var phone) {
                  setState(() {
                    phoneNumber = phone.phoneNumber!;
                  });
                },
                spaceBetweenSelectorAndTextField: 0,
                inputDecoration: kInputDecoration("Enter a Phone Number"),
                textStyle: kSubHeadingTextStyle,
                validator: ValidationBuilder().minLength(8).valueRequired().build(),
                autoValidateMode: AutovalidateMode.onUserInteraction,
                selectorTextStyle: kSubHeadingTextStyle,
                locale: "IN",
                selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                ),
              ),
            ),
            const SizedBox(height: kDefaultPadding),
            AnimatedContainer(
              height: otpSent ? 55 : 0,
              duration: const Duration(milliseconds: 300),
              child: TextInputContainer(
                icon: Icons.phone,
                child: TextFormField(
                  onChanged: (value) => setState(() {
                    otp = value;
                  }),
                  obscureText: true,
                  validator: ValidationBuilder().minLength(10).valueRequired().build(),
                  keyboardType: TextInputType.number,
                  decoration: kInputDecoration("otp"),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.15),
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
    final AuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
    UserCredential value = await FirebaseAuth.instance.signInWithCredential(credential);
    if (await checkUserExists(value.user!.uid)) {
      MembershipProvider membershipProvider =
          Provider.of<MembershipProvider>(context, listen: false);
      await membershipProvider.logInUser(value.user!.uid);
      Navigator.pushReplacement(context, FadeRoute(page: const HomePage()));
    } else {
      Navigator.pushReplacement(
        context,
        FadeRoute(
          page: RegisterUserPage(
            uid: value.user!.uid,
            phoneNumber: phoneNumber,
          ),
        ),
      );
    }
  }
}
