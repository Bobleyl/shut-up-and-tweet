import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:clipboard/clipboard.dart';

import '../util/responsive_widget.dart';
import '../util/flutterfire_firestore.dart';

import '../widgets/widgets.dart';

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
  TextEditingController checklistController = TextEditingController();
  ScrollController scrollListController =
      ScrollController(initialScrollOffset: 45.0);
  ScrollController smallScrollListController =
      ScrollController(initialScrollOffset: 25.0);

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

    void showCenterFlash({
      FlashPosition position,
      FlashStyle style,
      Alignment alignment,
      String message,
    }) {
      showFlash(
        context: context,
        duration: Duration(seconds: 3),
        builder: (_, controller) {
          return Flash(
            controller: controller,
            backgroundColor: Colors.black,
            borderRadius: BorderRadius.circular(5.0),
            borderColor: Colors.red,
            position: position,
            style: style,
            alignment: alignment,
            enableDrag: false,
            onTap: () => controller.dismiss(),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: DefaultTextStyle(
                style: GoogleFonts.roboto(
                  color: Colors.white,
                ),
                child: Text(
                  message,
                ),
              ),
            ),
          );
        },
      );
    }

    Color countColor(String word) {
      if (word.length > 280) {
        return Colors.red;
      } else {
        return Colors.black;
      }
    }

    AwesomeDialog showPopup(int section) {
      AwesomeDialog dialog;
      dialog = AwesomeDialog(
        context: context,
        width: screenSize.width / 2,
        animType: AnimType.SCALE,
        dialogType: DialogType.NO_HEADER,
        body: StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff45535e),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            cursorColor: Colors.white,
                            controller: tweetController,
                            onChanged: (value) {
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              hintText: "Enter Tweet Here",
                              hintStyle: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Color(0xff45535e),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Color(0xff45535e),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Color(0xff45535e),
                                ),
                              ),
                            ),
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                            maxLines: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  right: 5.0,
                                  bottom: 5.0,
                                ),
                                child: Text(
                                  (280 - tweetController.text.length)
                                      .toString(),
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    color: countColor(
                                      tweetController.text,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Color(0xff243341),
                      ),
                      child: MaterialButton(
                        onPressed: () async {
                          if (tweetController.text.length > 280) {
                            showCenterFlash(
                              alignment: Alignment.center,
                              message: 'You need to shorten your tweet',
                            );
                          } else {
                            await addTweet(
                                tweetController.text, sections[section]);
                            tweetController.text = "";
                            dialog.dissmiss();
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0) +
                              EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(
                            "Add Tweet",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        title: 'This is Ignored',
        desc: 'This is also Ignored',
      )..show();
      return dialog;
    }

    AwesomeDialog showSmallPopup(int section) {
      AwesomeDialog dialog;
      dialog = AwesomeDialog(
        context: context,
        width: screenSize.width / 1,
        animType: AnimType.SCALE,
        dialogType: DialogType.NO_HEADER,
        body: StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff45535e),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            cursorColor: Colors.white,
                            controller: tweetController,
                            onChanged: (value) {
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              hintText: "Enter Tweet Here",
                              hintStyle: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Color(0xff45535e),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Color(0xff45535e),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Color(0xff45535e),
                                ),
                              ),
                            ),
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                            maxLines: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  right: 5.0,
                                  bottom: 5.0,
                                ),
                                child: Text(
                                  (280 - tweetController.text.length)
                                      .toString(),
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    color: countColor(
                                      tweetController.text,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Color(0xff243341),
                      ),
                      child: MaterialButton(
                        onPressed: () async {
                          if (tweetController.text.length > 280) {
                            showCenterFlash(
                              alignment: Alignment.center,
                              message: 'You need to shorten your tweet',
                            );
                          } else {
                            await addTweet(
                                tweetController.text, sections[section]);
                            tweetController.text = "";
                            dialog.dissmiss();
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0) +
                              EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(
                            "Add Tweet",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        title: 'This is Ignored',
        desc: 'This is also Ignored',
      )..show();
      return dialog;
    }

    AwesomeDialog addToChecklist(double size) {
      AwesomeDialog dialog;
      dialog = AwesomeDialog(
        context: context,
        width: screenSize.width / size,
        animType: AnimType.SCALE,
        dialogType: DialogType.NO_HEADER,
        body: StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff45535e),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            cursorColor: Colors.white,
                            controller: checklistController,
                            decoration: InputDecoration(
                              hintText: "Enter Daily Checklist Task Here",
                              hintStyle: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Color(0xff45535e),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Color(0xff45535e),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Color(0xff45535e),
                                ),
                              ),
                            ),
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Color(0xff243341),
                      ),
                      child: MaterialButton(
                        onPressed: () async {
                          await addItemToChecklist(checklistController.text);
                          checklistController.text = "";
                          dialog.dissmiss();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0) +
                              EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(
                            "Add Task",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        title: 'This is Ignored',
        desc: 'This is also Ignored',
      )..show();
      return dialog;
    }

    Widget gridBox(int section) {
      return Container(
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
                  .doc(sections[section])
                  .collection("Backlog")
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
                            decoration: BoxDecoration(
                              color: Color(0xff15202b),
                            ),
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
                                          color: Color(0xff45535e),
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
                                              message: 'Copied Tweet');
                                        },
                                        icon: Icon(
                                          Icons.copy,
                                          color: Color(0xff45535e),
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
                          actions: <Widget>[
                            IconSlideAction(
                              caption: 'Archive',
                              color: Colors.blue,
                              icon: Icons.archive,
                              onTap: () async {
                                await archiveTweet(document.id,
                                    document['Tweet'], sections[section]);
                              },
                            ),
                          ],
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
                        sectionTitles[section],
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
                          showPopup(section);
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
      );
    }

    Widget gridBoxSmall(int section) {
      return Container(
        decoration: BoxDecoration(
          color: Color(0xff243341),
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
                  .collection("Backlog")
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
                            decoration: BoxDecoration(
                              color: Color(0xff15202b),
                            ),
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
                                          color: Color(0xff45535e),
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
                                              message: 'Copied Tweet');
                                        },
                                        icon: Icon(
                                          Icons.copy,
                                          color: Color(0xff45535e),
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
                          actions: <Widget>[
                            IconSlideAction(
                              caption: 'Archive',
                              color: Colors.blue,
                              icon: Icons.archive,
                              onTap: () async {
                                await archiveTweet(document.id,
                                    document['Tweet'], sections[section]);
                              },
                            ),
                          ],
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
                        sectionTitles[section],
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: IconButton(
                        onPressed: () {
                          showSmallPopup(section);
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

    final checklist = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xff243341),
            borderRadius: BorderRadius.circular(5.0),
          ),
          height: screenSize.height / 2.5,
          width: screenSize.width / 1.8,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(25),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .collection('Checklist')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView(
                      controller: scrollListController,
                      children: snapshot.data.docs.map((document) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xff15202b),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            width: screenSize.width / 1.4,
                            child: Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              child: Container(
                                width: screenSize.width / 1.4,
                                decoration: BoxDecoration(
                                  color: Color(0xff15202b),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(7),
                                  child: Row(
                                    children: [
                                      CircularCheckBox(
                                        value: document.data()['Done'],
                                        checkColor: Colors.white,
                                        activeColor: Colors.green,
                                        inactiveColor: Colors.redAccent,
                                        disabledColor: Colors.grey,
                                        onChanged: (value) async {
                                          await checkItem(document.id, value);
                                        },
                                      ),
                                      Expanded(
                                        child: Text(
                                          document.data()['Item'],
                                          style: GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
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
                                    await deleteFromChecklist(document.id);
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
              ),
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
                          "Daily Checklist",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: IconButton(
                          onPressed: () {
                            addToChecklist(2);
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
          width: screenSize.width / 20,
        ),
        Container(
          decoration: BoxDecoration(
            color: Color(0xff243341),
            borderRadius: BorderRadius.circular(5.0),
          ),
          height: screenSize.height / 2.5,
          width: screenSize.width / 3.5,
          child: Center(
            child: Text(
              "Coming Soon: Analytics",
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );

    final checklistSmall = Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xff243341),
            borderRadius: BorderRadius.circular(5.0),
          ),
          height: screenSize.height / 2.5,
          width: screenSize.width / 1.2,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(25),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .collection('Checklist')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView(
                      controller: smallScrollListController,
                      children: snapshot.data.docs.map((document) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xff15202b),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            width: screenSize.width / 1.4,
                            child: Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              child: Container(
                                width: screenSize.width / 1.4,
                                decoration: BoxDecoration(
                                  color: Color(0xff15202b),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(7),
                                  child: Row(
                                    children: [
                                      CircularCheckBox(
                                        value: document.data()['Done'],
                                        checkColor: Colors.white,
                                        activeColor: Colors.green,
                                        inactiveColor: Colors.redAccent,
                                        disabledColor: Colors.grey,
                                        onChanged: (value) async {
                                          await checkItem(document.id, value);
                                        },
                                      ),
                                      Expanded(
                                        child: Text(
                                          document.data()['Item'],
                                          style: GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
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
                                    await deleteFromChecklist(document.id);
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
              ),
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
                          "Daily Checklist",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: IconButton(
                          onPressed: () {
                            addToChecklist(1);
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
      ],
    );

    return ResponsiveWidget(
      largeScreen: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: screenSize.height / 20),
          checklist,
          SizedBox(height: screenSize.height / 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Tweet Backlog",
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
            ],
          ),
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
          checklistSmall,
          SizedBox(height: screenSize.height / 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Tweet Backlog",
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
            ],
          ),
          SizedBox(height: screenSize.height / 20),
          profileDataSmall,
          SizedBox(height: screenSize.height / 20),
        ],
      ),
    );
  }
}
