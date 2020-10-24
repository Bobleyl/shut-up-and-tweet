import 'package:flutter/material.dart';
import 'package:shut_up_and_tweet/ui/theme/colors.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import '../util/responsive_widget.dart';
import '../util/my_flutter_app_icons.dart' as CustomIcons;

class SocialInfo extends StatelessWidget {
  List<Widget> socialMediaWidgets() {
    return [
      IconButton(
        icon: Icon(
          CustomIcons.MyFlutterApp.github_squared,
          color: AppColors().bleylDevPurple,
        ),
        onPressed: () {
          html.window.open(
            "https://github.com/Bobleyl",
            "Github",
          );
        },
      ),
      IconButton(
        icon: Icon(
          CustomIcons.MyFlutterApp.twitter_squared,
          color: AppColors().bleylDevPurple,
        ),
        onPressed: () {
          html.window.open(
            "https://twitter.com/bleyldev",
            "Twitter",
          );
        },
      ),
      IconButton(
        icon: Icon(
          CustomIcons.MyFlutterApp.youtube_squared,
          color: AppColors().bleylDevPurple,
        ),
        onPressed: () {
          html.window.open(
            "https://www.youtube.com/c/BleylDev?sub_confirmation=1",
            "Youtube",
          );
        },
      ),
      IconButton(
        icon: Icon(
          CustomIcons.MyFlutterApp.medium,
          color: AppColors().bleylDevPurple,
        ),
        onPressed: () {
          html.window.open(
            "https://medium.com/@bleyldev",
            "Medium",
          );
        },
      ),
      IconButton(
        icon: Icon(
          CustomIcons.MyFlutterApp.discord,
          color: AppColors().bleylDevPurple,
        ),
        onPressed: () {
          html.window.open(
            "https://discord.gg/aUQj87U",
            "Discord",
          );
        },
      ),
    ];
  }

  Widget copyRightText() => Padding(
        padding: EdgeInsets.only(
          right: 20,
        ),
        child: Text(
          "Bleyl Dev ©️2020",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      largeScreen: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: socialMediaWidgets(),
          ),
          copyRightText(),
        ],
      ),
      smallScreen: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ...socialMediaWidgets(),
          copyRightText(),
        ],
      ),
    );
  }
}
