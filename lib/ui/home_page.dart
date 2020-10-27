import 'package:circular_check_box/circular_check_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shut_up_and_tweet/model/tweet.dart';
import 'package:shut_up_and_tweet/model/user.dart';
import 'package:shut_up_and_tweet/ui/theme/colors.dart';
import 'package:shut_up_and_tweet/util/twitter_api.dart';
import 'package:shut_up_and_tweet/widgets/admin_panel.dart';
import 'package:shut_up_and_tweet/widgets/dialogs.dart';
import 'package:shut_up_and_tweet/widgets/gridbox.dart';

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
  UserData user = new UserData("", 0, 0, "", "", 0, 0);
  List<Tweet> tweets = [];
  TextEditingController checklistController = TextEditingController();

  @override
  // ignore: must_call_super
  void initState() {
    getSections();
  }

  getSections() async {
    sections = await getStrategySectionIds();
    sectionTitles = await getStrategySections();
    handle = await getHandle();
    user = await getUserInfo(handle);
    tweets = await getTweets(handle);
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
            gridBox(context, 0, sections, sectionTitles, handle),
            SizedBox(
              width: screenSize.width / 40,
            ),
            gridBox(context, 1, sections, sectionTitles, handle),
          ],
        ),
        SizedBox(
          height: screenSize.height / 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            gridBox(context, 2, sections, sectionTitles, handle),
            SizedBox(
              width: screenSize.width / 40,
            ),
            gridBox(context, 3, sections, sectionTitles, handle),
          ],
        ),
      ],
    );

    final profileDataSmall = Column(
      children: [
        gridBoxSmall(context, 0, sections, sectionTitles, handle),
        SizedBox(
          height: screenSize.height / 40,
        ),
        gridBoxSmall(context, 1, sections, sectionTitles, handle),
        SizedBox(
          height: screenSize.height / 40,
        ),
        gridBoxSmall(context, 2, sections, sectionTitles, handle),
        SizedBox(
          height: screenSize.height / 40,
        ),
        gridBoxSmall(context, 3, sections, sectionTitles, handle),
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
            color: AppColors().mediumTwitter,
            borderRadius: BorderRadius.circular(5.0),
          ),
          height: screenSize.height / 2.5,
          width: screenSize.width / 1.8,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(25) + EdgeInsets.only(top: 35),
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

                    return MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView(
                        children: snapshot.data.docs.map((document) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors().darkTwitter,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              width: screenSize.width / 1.4,
                              child: Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                child: Container(
                                  width: screenSize.width / 1.4,
                                  decoration: BoxDecoration(
                                    color: AppColors().darkTwitter,
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
                      ),
                    );
                  },
                ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 5,
                        child: IconButton(
                          onPressed: () {
                            helpDialog(
                              2.5,
                              "You daily checklist is a list of daily tasks and goals you want to accomplish on Twitter.  All tasks will reset at midnight, local time.  Delete tasks by swiping left.",
                              context,
                            );
                          },
                          icon: Icon(
                            Icons.help_outline_outlined,
                            color: Colors.white,
                          ),
                        ),
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
                            addToChecklist(
                              2,
                              checklistController,
                              context,
                            );
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
        adminPanel(
          user,
          3.5,
          tweets,
          context,
        ),
      ],
    );

    final checklistSmall = Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors().mediumTwitter,
            borderRadius: BorderRadius.circular(5.0),
          ),
          height: screenSize.height / 2.5,
          width: screenSize.width / 1.2,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(25) + EdgeInsets.only(top: 35),
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

                    return MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView(
                        children: snapshot.data.docs.map((document) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors().darkTwitter,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              width: screenSize.width / 1.4,
                              child: Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                child: Container(
                                  width: screenSize.width / 1.4,
                                  decoration: BoxDecoration(
                                    color: AppColors().darkTwitter,
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
                      ),
                    );
                  },
                ),
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
                            addToChecklist(
                              1,
                              checklistController,
                              context,
                            );
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

    final goalPanel = Container(
      decoration: BoxDecoration(
        color: AppColors().mediumTwitter,
        borderRadius: BorderRadius.circular(5.0),
      ),
      height: screenSize.height / 2.5,
      width: screenSize.width / 1.12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors().darkTwitter,
              borderRadius: BorderRadius.circular(5.0),
            ),
            width: screenSize.width / 4,
            height: screenSize.height / 3,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                    "Followers Goal",
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user?.followers.toString(),
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                    Text(
                      "/",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser.uid)
                          .collection('Goals')
                          .doc("Followers")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }

                        return Text(
                          snapshot.data.data()['Goal'].toString(),
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: AppColors().mediumTwitter,
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      await changeFollowerGoal(1500);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0) +
                          EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        "Change Goal",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors().darkTwitter,
              borderRadius: BorderRadius.circular(5.0),
            ),
            width: screenSize.width / 4,
            height: screenSize.height / 3,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                    "Tweets Goal",
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "938",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                    Text(
                      "/",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                    Text(
                      "1200",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors().darkTwitter,
              borderRadius: BorderRadius.circular(5.0),
            ),
            width: screenSize.width / 4,
            height: screenSize.height / 3,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                    "Impressions Goal",
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "211",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                    Text(
                      "/",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                    Text(
                      "350",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                  ],
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
          //SizedBox(height: screenSize.height / 20),
          //goalPanel,
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
              IconButton(
                onPressed: () {
                  helpDialog(
                    2.5,
                    "Your backlog contains a list of planned tweets to post the following week or month.  You can fill it up with as many or little tweets as you can think of in advance.  Once you're ready to post a tweet, you can simply click the copy button on the tweet and add it to Twitter.  Tweets can be separated into different categories to help your brand cover a wide variety of types of social interactions with potential followers.",
                    context,
                  );
                },
                icon: Icon(
                  Icons.help_outline_outlined,
                  color: Colors.white,
                  size: 25,
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
          adminPanel(
            user,
            1.2,
            tweets,
            context,
          ),
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
