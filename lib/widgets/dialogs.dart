import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shut_up_and_tweet/ui/theme/colors.dart';
import 'package:shut_up_and_tweet/util/flutterfire_firestore.dart';

Color countColor(String word) {
  if (word.length > 280) {
    return Colors.red;
  } else {
    return Colors.black;
  }
}

void showCenterFlash({
  FlashPosition position,
  FlashStyle style,
  Alignment alignment,
  String message,
  BuildContext context,
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

AwesomeDialog showPopup(
  int section,
  TextEditingController tweetController,
  List<String> sections,
  int size,
  BuildContext context,
) {
  AwesomeDialog dialog;
  dialog = AwesomeDialog(
    context: context,
    width: MediaQuery.of(context).size.width / size,
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
                    color: AppColors().lightTwitter,
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
                              color: AppColors().lightTwitter,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: AppColors().lightTwitter,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: AppColors().lightTwitter,
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
                              (280 - tweetController.text.length).toString(),
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
                    color: AppColors().mediumTwitter,
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      if (tweetController.text.length > 280) {
                        showCenterFlash(
                          alignment: Alignment.center,
                          message: 'You need to shorten your tweet',
                        );
                      } else {
                        await addTweet(tweetController.text, sections[section]);
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

AwesomeDialog addToChecklist(
  double size,
  TextEditingController checklistController,
  BuildContext context,
) {
  AwesomeDialog dialog;
  dialog = AwesomeDialog(
    context: context,
    width: MediaQuery.of(context).size.width / size,
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
                    color: AppColors().lightTwitter,
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
                              color: AppColors().lightTwitter,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: AppColors().lightTwitter,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: AppColors().lightTwitter,
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
                    color: AppColors().mediumTwitter,
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

AwesomeDialog changeStrategyName(
  double size,
  String id,
  TextEditingController strategyController,
  BuildContext context,
) {
  AwesomeDialog dialog;
  dialog = AwesomeDialog(
    context: context,
    width: MediaQuery.of(context).size.width / size,
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
                    ) +
                    EdgeInsets.only(
                      top: 30,
                      bottom: 10,
                    ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors().lightTwitter,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        cursorColor: Colors.white,
                        controller: strategyController,
                        decoration: InputDecoration(
                          hintText: "Enter New Strategy Name",
                          hintStyle: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: AppColors().lightTwitter,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: AppColors().lightTwitter,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: AppColors().lightTwitter,
                            ),
                          ),
                        ),
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 5.0,
                  bottom: 10,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: AppColors().mediumTwitter,
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      await updateStrategyName(id, strategyController.text);
                      strategyController.text = "";
                      dialog.dissmiss();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0) +
                          EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        "Change Section Title",
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

AwesomeDialog helpDialog(
  double size,
  String helpText,
  BuildContext context,
) {
  AwesomeDialog dialog;
  dialog = AwesomeDialog(
    context: context,
    width: MediaQuery.of(context).size.width / size,
    animType: AnimType.SCALE,
    dialogType: DialogType.NO_HEADER,
    body: Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Container(
              child: Text(
                helpText,
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 25,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: AppColors().mediumTwitter,
            ),
            child: MaterialButton(
              onPressed: () {
                dialog.dissmiss();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0) +
                    EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  "Close",
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
    title: 'This is Ignored',
    desc: 'This is also Ignored',
  )..show();
  return dialog;
}
