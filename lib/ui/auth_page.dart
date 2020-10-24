import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shut_up_and_tweet/ui/home_page.dart';
import 'package:shut_up_and_tweet/ui/theme/colors.dart';
import 'package:shut_up_and_tweet/util/flutterfire_auth_service.dart';
import 'package:shut_up_and_tweet/util/flutterfire_firestore.dart';
import '../util/responsive_widget.dart';
import 'package:provider/provider.dart';

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
          color: AppColors().darkTwitter,
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
        color: AppColors().darkTwitter,
      ),
      width: screenSize.width,
      height: screenSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors().twitterBlue,
            ),
            width: screenSize.width / 2,
            height: screenSize.height,
            child: Padding(
              padding: EdgeInsets.only(
                left: screenSize.width / 7,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.assessment,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Set Goals",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenSize.height / 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.fast_forward_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Plan Ahead",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenSize.height / 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.show_chart_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Analyze Results",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: screenSize.width / 2,
            height: screenSize.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenSize.width / 3,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Manage your brand to it's fullest potential!",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenSize.height / 20,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: screenSize.width / 12,
                    bottom: screenSize.height / 80,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Join Today",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    context
                        .read<FlutterFireAuthService>()
                        .twitterSignIn()
                        .then((credential) async {
                      await addUser(credential.additionalUserInfo.username);
                      await sameDayCheck();
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color(0xff1ea2f1),
                      ),
                      width: screenSize.width / 3,
                      height: 40,
                      child: Text(
                        "Sign Up / In",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 25.0,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final profileDataSmall = Container(
      decoration: BoxDecoration(
        color: AppColors().darkTwitter,
      ),
      width: screenSize.width,
      height: screenSize.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors().twitterBlue,
            ),
            width: screenSize.width,
            height: screenSize.height / 2,
            child: Padding(
              padding: EdgeInsets.only(
                left: screenSize.width / 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.assessment,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Set Goals",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenSize.height / 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.fast_forward_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Plan Ahead",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenSize.height / 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.show_chart_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Analyze Results",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: screenSize.width,
            height: screenSize.height / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenSize.width / 1.2,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Manage your brand to it's fullest potential!",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenSize.height / 20,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: screenSize.width / 12,
                    bottom: screenSize.height / 40,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Join Today",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    context
                        .read<FlutterFireAuthService>()
                        .twitterSignIn()
                        .then((credential) async {
                      await addUser(credential.additionalUserInfo.username);
                      await sameDayCheck();
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color(0xff1ea2f1),
                      ),
                      width: screenSize.width / 1.2,
                      height: 40,
                      child: Text(
                        "Sign Up / In",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 25.0,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return ResponsiveWidget(
      largeScreen: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          profileData,
        ],
      ),
      smallScreen: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          profileDataSmall,
        ],
      ),
    );
  }
}
