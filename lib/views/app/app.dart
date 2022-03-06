import 'package:TomoChat/providers/channel.dart';
import 'package:TomoChat/providers/user.dart';
import 'package:TomoChat/themes/theme.dart';
import 'package:TomoChat/utils/contact_info.dart';
import 'package:TomoChat/views/home_page.dart';
import 'package:TomoChat/views/membership/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TomoApp extends StatefulWidget {
  const TomoApp({Key? key}) : super(key: key);

  @override
  State<TomoApp> createState() => _TomoAppState();
}

class _TomoAppState extends State<TomoApp> {
  bool? _loggedIn;
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
            askPermissions(context).then((value) {
              
            });
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
