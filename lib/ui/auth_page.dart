import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shut_up_and_tweet/ui/home_page.dart';
import 'package:shut_up_and_tweet/util/flutterfire_auth_service.dart';
import 'package:shut_up_and_tweet/util/flutterfire_firestore.dart';
import '../util/responsive_widget.dart';
import 'package:provider/provider.dart';
import '../util/my_flutter_app_icons.dart' as CustomIcons;

import '../widgets/widgets.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  ScrollController _scrollController;
  double _scrollPosition = 0;
  double opacity = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      print("Home View");
      return HomePage();
    }

    var screenSize = MediaQuery.of(context).size;
    opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage("assets/backdrop.png"),
          ),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              HomeInfo(),
              SocialInfo(),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeInfo extends StatefulWidget {
  HomeInfo({Key key}) : super(key: key);

  @override
  _HomeInfoState createState() => _HomeInfoState();
}

class _HomeInfoState extends State<HomeInfo> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    final profileData = Container(
        decoration: BoxDecoration(
          color: Color(0xff243341),
          borderRadius: BorderRadius.circular(5.0),
        ),
        width: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: screenSize.height / 10,
            ),
            Image.asset(
              'assets/logo_appbar.png',
              height: 100,
            ),
            SizedBox(
              height: screenSize.height / 10,
            ),
            MaterialButton(
              onPressed: () {
                context
                    .read<FlutterFireAuthService>()
                    .twitterSignIn()
                    .then((credential) async {
                  await addUser(credential.additionalUserInfo.username);
                  await setUpGrid();
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
                    color: Color(0xff1ea2f1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        CustomIcons.MyFlutterApp.twitter_squared,
                        color: Colors.white,
                        size: 50,
                      ),
                      Text(
                        "Log In With Twitter",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenSize.height / 10,
            ),
          ],
        ));

    return ResponsiveWidget(
      largeScreen: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: screenSize.height / 3),
          profileData,
          SizedBox(height: screenSize.height / 3),
        ],
      ),
      smallScreen: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: screenSize.height / 3),
          profileData,
          SizedBox(height: screenSize.height / 3),
        ],
      ),
    );
  }
}
