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

class _HomeInfoState extends State<HomeInfo> with TickerProviderStateMixin {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _handleController = TextEditingController();
  TabController tabController;
  bool signIn = true;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    tabs() {
      if (signIn == true) {
        return Container(
          width: screenSize.width / 2.6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
            ),
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
            ],
          ),
        );
      } else {
        return Container(
          width: screenSize.width / 2.6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
            ),
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
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 50,
                ),
                child: TextFormField(
                  controller: _handleController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "@twitterhandle",
                    hintStyle: GoogleFonts.roboto(
                      color: Colors.white,
                    ),
                    labelText: "Twitter Handle",
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
                    context.read<FlutterFireAuthService>().signUp(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                          twitterHandle: _handleController.text.trim(),
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
        );
      }
    }

    Color signInColor() {
      if (signIn) {
        return Color(0xff15202b);
      } else {
        return Color(0xff45535e);
      }
    }

    Color signUpColor() {
      if (signIn) {
        return Color(0xff45535e);
      } else {
        return Color(0xff15202b);
      }
    }

    Color signUpBoder() {
      if (signIn) {
        return Color(0xff45535e);
      } else {
        return Colors.white;
      }
    }

    Color signInBorder() {
      if (!signIn) {
        return Color(0xff45535e);
      } else {
        return Colors.white;
      }
    }

    final profileData = Column(
      children: [
        SizedBox(
          height: screenSize.height / 3.7,
        ),
        Container(
          width: screenSize.width / 2.6,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: signInColor(),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                    ),
                    border: Border.all(color: signInBorder()),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          signIn = true;
                        });
                      },
                      child: Text(
                        "Sign In",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: signUpColor(),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.0),
                    ),
                    border: Border.all(color: signUpBoder()),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          signIn = false;
                        });
                      },
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        tabs(),
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
