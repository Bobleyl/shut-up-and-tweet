import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shut_up_and_tweet/home_page.dart';
import 'package:shut_up_and_tweet/util/flutterfire_auth_service.dart';
import 'util/responsive_widget.dart';
import 'package:provider/provider.dart';

import 'widgets/widgets.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  ScrollController _scrollController;
  double _scrollPosition = 0;
  double _opacity = 0;

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
    _opacity = _scrollPosition < screenSize.height * 0.40
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
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final profileData = Column(
      children: [
        SizedBox(
          height: screenSize.height / 3.7,
        ),
        Container(
          width: screenSize.width / 2.6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Color(0xff15202b),
          ),
          child: Column(
            children: [
              SizedBox(
                height: screenSize.height / 40,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 50,
                ),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "something@email.com",
                    hintStyle: GoogleFonts.roboto(
                      color: Colors.white,
                    ),
                    labelText: "Email",
                    labelStyle: GoogleFonts.roboto(
                      color: Colors.white,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                  ),
                  cursorColor: Colors.white,
                ),
              ),
              SizedBox(
                height: screenSize.height / 40,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 50,
                ),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "password",
                    hintStyle: GoogleFonts.roboto(
                      color: Colors.white,
                    ),
                    labelText: "Password",
                    labelStyle: GoogleFonts.roboto(
                      color: Colors.white,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                  ),
                  cursorColor: Colors.white,
                ),
              ),
              SizedBox(
                height: screenSize.height / 40,
              ),
              Container(
                width: 200,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: MaterialButton(
                  onPressed: () {
                    context.read<FlutterFireAuthService>().signIn(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                          context: context,
                        );
                  },
                  child: Text(
                    "Sign In",
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenSize.height / 40,
              ),
              Container(
                width: 200,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: MaterialButton(
                  onPressed: () {
                    context.read<FlutterFireAuthService>().signUp(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                          context: context,
                        );
                  },
                  child: Text(
                    "Sign Up",
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenSize.height / 40,
              ),
            ],
          ),
        ),
        SizedBox(
          height: screenSize.height / 3.7,
        ),
      ],
    );

    final profileDataSmall = Stack(
      children: [
        Container(
          child: SizedBox(
            width: screenSize.width,
            height: screenSize.height,
            child: Image.asset(
              'assets/home_banner_tall.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );

    return ResponsiveWidget(
      largeScreen: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          profileData,
          SizedBox(height: screenSize.height / 20),
        ],
      ),
      smallScreen: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          profileDataSmall,
          SizedBox(height: screenSize.height / 20),
        ],
      ),
    );
  }
}
