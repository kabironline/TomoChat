import 'package:chat_app/providers/channel.dart';
import 'package:chat_app/providers/user.dart';
import 'package:chat_app/services/user/user_sign_in.dart';
import 'package:chat_app/themes/theme.dart';
import 'package:chat_app/views/home_page.dart';
import 'package:chat_app/views/membership/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TomoApp extends StatefulWidget {
  const TomoApp({Key? key}) : super(key: key);

  @override
  State<TomoApp> createState() => _TomoAppState();
}

class _TomoAppState extends State<TomoApp> {
  bool? _loggedIn;
  // Future<Widget?> userSignedIn() async {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MembershipProvider()),
        ChangeNotifierProvider(create: (context) => ChannelProvider()),
      ],
      child: MaterialApp(
        title: 'Tomo',
        theme: getApplicationTheme(context),
        home: Consumer<MembershipProvider>(
          builder: (context, membership, _) {
            if (_loggedIn == null) {
              membership.isLoggedIn.then((loggedIn) {
                setState(() {
                  _loggedIn = loggedIn;
                });
              });
              return const CircularProgressIndicator();
            } else if (_loggedIn == true) {
              return const HomePage();
            } else {
              return LoginPage();
            }
          },
        ),
      ),
    );
  }
}