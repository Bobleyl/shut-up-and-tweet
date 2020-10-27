import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shut_up_and_tweet/ui/theme/colors.dart';
import 'package:shut_up_and_tweet/util/flutterfire_firestore.dart';

import 'dialogs.dart';

Widget gridBox(
  BuildContext context,
  int section,
  List<String> sections,
  List<String> sectionTitles,
  String handle,
) {
  TextEditingController tweetController = TextEditingController();
  TextEditingController strategyController = TextEditingController();
  return Container(
    decoration: BoxDecoration(
      color: AppColors().mediumTwitter,
      borderRadius: BorderRadius.circular(5.0),
    ),
    width: MediaQuery.of(context).size.width / 2.3,
    height: MediaQuery.of(context).size.height / 2.6,
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
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                        width: MediaQuery.of(context).size.width / 2.5,
                        decoration: BoxDecoration(
                          color: AppColors().darkTwitter,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          tweetController.text =
                                              document['Tweet'];
                                          showPopup(
                                            section,
                                            tweetController,
                                            sections,
                                            document.id,
                                            2,
                                            false,
                                            context,
                                          );
                                        },
                                        icon: Icon(
                                          Icons.edit_outlined,
                                          color: AppColors().lightTwitter,
                                          size: 18,
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
                                ],
                              ),
                              Text(
                                document['Tweet'],
                                maxLines: 5,
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  height: 1.1,
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
                            await archiveTweet(document.id, document['Tweet'],
                                sections[section]);
                          },
                        ),
                      ],
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () async {
                            await deleteTweet(document.id, sections[section]);
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 5,
                  child: SizedBox(width: 25.0),
                ),
                Flexible(
                  flex: 15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          sectionTitles[section],
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 30.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          changeStrategyName(
                            2.5,
                            sections[section],
                            strategyController,
                            context,
                          );
                        },
                        icon: Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: IconButton(
                    onPressed: () {
                      showPopup(
                        section,
                        tweetController,
                        sections,
                        "",
                        2,
                        true,
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
  );
}

Widget gridBoxSmall(
  BuildContext context,
  int section,
  List<String> sections,
  List<String> sectionTitles,
  String handle,
) {
  TextEditingController tweetController = TextEditingController();
  TextEditingController strategyController = TextEditingController();

  return Container(
    decoration: BoxDecoration(
      color: AppColors().mediumTwitter,
      borderRadius: BorderRadius.circular(5.0),
    ),
    width: MediaQuery.of(context).size.width / 1.2,
    height: MediaQuery.of(context).size.height / 2,
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
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                        width: MediaQuery.of(context).size.width / 1.4,
                        decoration: BoxDecoration(
                          color: AppColors().darkTwitter,
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
                                      color: AppColors().lightTwitter,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      FlutterClipboard.copy(document['Tweet']);
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
                      actions: <Widget>[
                        IconSlideAction(
                          caption: 'Archive',
                          color: Colors.blue,
                          icon: Icons.archive,
                          onTap: () async {
                            await archiveTweet(document.id, document['Tweet'],
                                sections[section]);
                          },
                        ),
                      ],
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () async {
                            await deleteTweet(document.id, sections[section]);
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 5,
                  child: SizedBox(width: 25.0),
                ),
                Flexible(
                  flex: 14,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          sectionTitles[section],
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 25.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          changeStrategyName(
                            1.2,
                            sections[section],
                            strategyController,
                            context,
                          );
                        },
                        icon: Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: IconButton(
                    onPressed: () {
                      showPopup(
                        section,
                        tweetController,
                        sections,
                        "",
                        1,
                        true,
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
  );
}
