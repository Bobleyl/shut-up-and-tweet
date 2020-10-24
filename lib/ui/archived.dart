import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:clipboard/clipboard.dart';
import 'package:shut_up_and_tweet/ui/theme/colors.dart';
import 'package:shut_up_and_tweet/widgets/dialogs.dart';

import '../util/responsive_widget.dart';
import '../util/flutterfire_firestore.dart';

import '../widgets/widgets.dart';

class ArchivedPage extends StatefulWidget {
  ArchivedPage({Key key}) : super(key: key);

  @override
  _ArchivedPageState createState() => _ArchivedPageState();
}

class _ArchivedPageState extends State<ArchivedPage> {
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
              backgroundColor: AppColors().bleylDevPurple.withOpacity(_opacity),
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

    Widget gridBox(int section) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors().mediumTwitter,
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
                  .doc(sections[section])
                  .collection("Archive")
                  .orderBy("Date", descending: false)
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
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: Container(
                            width: screenSize.width / 2.5,
                            decoration:
                                BoxDecoration(color: AppColors().darkTwitter),
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "@" + handle,
                                        style: GoogleFonts.roboto(
                                          color: AppColors().lightTwitter,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          FlutterClipboard.copy(
                                              document['Tweet']);
                                          showCenterFlash(
                                            position: FlashPosition.top,
                                            style: FlashStyle.floating,
                                            message: 'Copied Tweet',
                                            context: context,
                                          );
                                        },
                                        icon: Icon(
                                          Icons.copy,
                                          color: AppColors().lightTwitter,
                                          size: 18,
                                        ),
                                      ),
                                    ],
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
                            ),
                          ),
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () async {
                                await deleteTweet(
                                    document.id, sections[section]);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors().darkTwitter,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 25.0),
                    Text(
                      sectionTitles[section],
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 30.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget gridBoxSmall(int section) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors().mediumTwitter,
          borderRadius: BorderRadius.circular(5.0),
        ),
        width: screenSize.width / 1.2,
        height: screenSize.height / 2,
        child: Stack(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .collection('Strategy')
                  .doc(sections[section])
                  .collection("Archive")
                  .orderBy("Date", descending: false)
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
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: Container(
                            width: screenSize.width / 1.4,
                            decoration:
                                BoxDecoration(color: AppColors().darkTwitter),
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "@" + handle,
                                        style: GoogleFonts.roboto(
                                          color: AppColors().lightTwitter,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          FlutterClipboard.copy(
                                              document['Tweet']);
                                          showCenterFlash(
                                            position: FlashPosition.top,
                                            style: FlashStyle.floating,
                                            message: 'Copied Tweet',
                                            context: context,
                                          );
                                        },
                                        icon: Icon(
                                          Icons.copy,
                                          color: AppColors().lightTwitter,
                                          size: 18,
                                        ),
                                      ),
                                    ],
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
                            ),
                          ),
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () async {
                                await deleteTweet(
                                    document.id, sections[section]);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors().darkTwitter,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      sectionTitles[section],
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    final profileData = Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            gridBox(0),
            SizedBox(
              width: screenSize.width / 40,
            ),
            gridBox(1),
          ],
        ),
        SizedBox(
          height: screenSize.height / 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            gridBox(2),
            SizedBox(
              width: screenSize.width / 40,
            ),
            gridBox(3),
          ],
        ),
      ],
    );

    final profileDataSmall = Column(
      children: [
        gridBoxSmall(0),
        SizedBox(
          height: screenSize.height / 40,
        ),
        gridBoxSmall(1),
        SizedBox(
          height: screenSize.height / 40,
        ),
        gridBoxSmall(2),
        SizedBox(
          height: screenSize.height / 40,
        ),
        gridBoxSmall(3),
        SizedBox(
          height: screenSize.height / 40,
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
