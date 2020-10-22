import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shut_up_and_tweet/ui/archived.dart';
import 'package:shut_up_and_tweet/ui/auth_page.dart';
import 'package:shut_up_and_tweet/util/flutterfire_auth_service.dart';
import 'configure_nonweb.dart' if (dart.library.html) 'configure_web.dart';

import 'ui/home_page.dart';

void main() async {
  configureApp();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String route = '/home';
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/backdrop.png"), context);
    return MultiProvider(
      providers: [
        Provider<FlutterFireAuthService>(
          create: (_) => FlutterFireAuthService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<FlutterFireAuthService>().authStateChanges,
        )
      ],
      child: MaterialApp(
        title: 'Shut Up and Tweet',
        theme: ThemeData(
          bottomAppBarColor: Color(0xff8c53ff),
        ),
        initialRoute: '/',
        routes: {
          '/home': (context) => HomePage(),
          '/archived': (context) => ArchivedPage(),
        },
        debugShowCheckedModeBanner: false,
        home: AuthPage(),
      ),
    );
  }
}
