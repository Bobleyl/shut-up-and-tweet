import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'util/responsive_widget.dart';
import 'util/flutterfire_firestore.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'widgets/widgets.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ResponsiveWidget.isSmallScreen(context)
          ? AppBar(
              backgroundColor:
                  Theme.of(context).bottomAppBarColor.withOpacity(_opacity),
              elevation: 0,
              centerTitle: true,
            )
          : PreferredSize(
              preferredSize: Size(screenSize.width, 1000),
              child: TopBarContents(_opacity),
            ),
      drawer: ExploreDrawer(),
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
              SizedBox(
                height: screenSize.height / 10,
              ),
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
  List<String> sections = ["temp", "temp", "temp", "temp"];
  List<String> sectionTitles = ["", "", "", ""];
  String handle = "";
  TextEditingController tweetController = TextEditingController();

  @override
  // ignore: must_call_super
  void initState() {
    getSections();
  }

  getSections() async {
    sections = await getStrategySectionIds();
    sectionTitles = await getStrategySections();
    handle = await getHandle();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final profileData = Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xff243341),
                borderRadius: BorderRadius.circular(5.0),
              ),
              width: screenSize.width / 2.3,
              height: screenSize.height / 2.6,
              child: Stack(
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser.uid)
                          .collection('Strategy')
                          .doc(sections[0])
                          .collection("Backlog")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ListView(
                          children: snapshot.data.docs.map((document) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                ),
                                child: Container(
                                    width: screenSize.width / 2.5,
                                    decoration: BoxDecoration(
                                      color: Color(0xff15202b),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "@" + handle,
                                            style: GoogleFonts.roboto(
                                              color: Color(0xff45535e),
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            document['Tweet'],
                                            maxLines: 5,
                                            style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xff15202b),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 5.0,
                        bottom: 5.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 5,
                            child: SizedBox(width: 25.0),
                          ),
                          Flexible(
                            flex: 14,
                            child: Text(
                              sectionTitles[0],
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 30.0,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 5,
                            child: IconButton(
                              onPressed: () {
                                AwesomeDialog(
                                  context: context,
                                  width: screenSize.width / 2,
                                  animType: AnimType.SCALE,
                                  dialogType: DialogType.NO_HEADER,
                                  body: Center(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 30.0,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xff243341),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: TextFormField(
                                              cursorColor: Colors.white,
                                              controller: tweetController,
                                              decoration: InputDecoration(
                                                hintText: "Enter Tweet Here",
                                                hintStyle: GoogleFonts.roboto(
                                                  color: Colors.white,
                                                  fontSize: 20.0,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: BorderSide(
                                                    color: Color(0xff243341),
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: BorderSide(
                                                    color: Color(0xff243341),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: BorderSide(
                                                    color: Color(0xff243341),
                                                  ),
                                                ),
                                              ),
                                              style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 20.0,
                                              ),
                                              maxLines: 5,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: MaterialButton(
                                            onPressed: () {},
                                            child: Text("Add Tweet"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  title: 'This is Ignored',
                                  desc: 'This is also Ignored',
                                )..show();
                              },
                              icon: Icon(
                                Icons.add_circle_outline,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: screenSize.width / 40,
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xff243341),
                borderRadius: BorderRadius.circular(5.0),
              ),
              width: screenSize.width / 2.3,
              height: screenSize.height / 2.6,
              child: Stack(
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser.uid)
                          .collection('Strategy')
                          .doc(sections[1])
                          .collection("Backlog")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ListView(
                          children: snapshot.data.docs.map((document) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                ),
                                child: Container(
                                    width: screenSize.width / 2.5,
                                    decoration: BoxDecoration(
                                      color: Color(0xff15202b),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "@" + handle,
                                            style: GoogleFonts.roboto(
                                              color: Color(0xff45535e),
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            document['Tweet'],
                                            maxLines: 5,
                                            style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xff15202b),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 5.0,
                        bottom: 5.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 5,
                            child: SizedBox(width: 25.0),
                          ),
                          Flexible(
                            flex: 14,
                            child: Text(
                              sectionTitles[1],
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 30.0,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 5,
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.add_circle_outline,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: screenSize.height / 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xff243341),
                borderRadius: BorderRadius.circular(5.0),
              ),
              width: screenSize.width / 2.3,
              height: screenSize.height / 2.6,
              child: Stack(
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser.uid)
                          .collection('Strategy')
                          .doc(sections[2])
                          .collection("Backlog")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ListView(
                          children: snapshot.data.docs.map((document) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                ),
                                child: Container(
                                    width: screenSize.width / 2.5,
                                    decoration: BoxDecoration(
                                      color: Color(0xff15202b),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "@" + handle,
                                            style: GoogleFonts.roboto(
                                              color: Color(0xff45535e),
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            document['Tweet'],
                                            maxLines: 5,
                                            style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xff15202b),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 5.0,
                        bottom: 5.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 5,
                            child: SizedBox(width: 25.0),
                          ),
                          Flexible(
                            flex: 14,
                            child: Text(
                              sectionTitles[2],
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 30.0,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 5,
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.add_circle_outline,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: screenSize.width / 40,
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xff243341),
                borderRadius: BorderRadius.circular(5.0),
              ),
              width: screenSize.width / 2.3,
              height: screenSize.height / 2.6,
              child: Stack(
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser.uid)
                          .collection('Strategy')
                          .doc(sections[3])
                          .collection("Backlog")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ListView(
                          children: snapshot.data.docs.map((document) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                ),
                                child: Container(
                                    width: screenSize.width / 2.5,
                                    decoration: BoxDecoration(
                                      color: Color(0xff15202b),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "@" + handle,
                                            style: GoogleFonts.roboto(
                                              color: Color(0xff45535e),
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            document['Tweet'],
                                            maxLines: 5,
                                            style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xff15202b),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 5.0,
                        bottom: 5.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 5,
                            child: SizedBox(width: 25.0),
                          ),
                          Flexible(
                            flex: 14,
                            child: Text(
                              sectionTitles[3],
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 30.0,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 5,
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.add_circle_outline,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
          SizedBox(height: screenSize.height / 20),
          profileData,
          SizedBox(height: screenSize.height / 20),
        ],
      ),
      smallScreen: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: screenSize.height / 20),
          profileDataSmall,
          SizedBox(height: screenSize.height / 20),
        ],
      ),
    );
  }
}
