import 'package:TomoChat/providers/channel.dart';
import 'package:TomoChat/providers/user.dart';
import 'package:TomoChat/themes/theme.dart';
import 'package:TomoChat/utils/contact_info.dart';
import 'package:TomoChat/views/chat/channel_edit_page.dart';
import 'package:TomoChat/views/chat/chat_detail_page.dart';
import 'package:TomoChat/views/chat/chat_page.dart';
import 'package:TomoChat/views/home_page.dart';
import 'package:TomoChat/views/membership/login_page.dart';
import 'package:TomoChat/views/membership/user_profile_page.dart';
import 'package:TomoChat/views/search_page.dart';
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
        routes: {
          '/home': (context) => const HomePage(),
          '/chat': (context) => const ChatPage(),
          '/profile': (context) => UserProfilePage(),
          '/chat/detail': (context) => ChatDetailPage(),
          '/chat/edit': (context) => const ChatEditPage(),
          '/search': (context) => SearchPage(),
        },
        theme: getApplicationTheme(context),
        home: Consumer<MembershipProvider>(
          builder: (context, membership, _) {
            return FutureBuilder(
              future: askPermissions(context),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
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
              }),
            );
          },
        ),
      ),
    );
  }
}
