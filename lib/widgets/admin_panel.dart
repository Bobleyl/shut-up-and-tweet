import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shut_up_and_tweet/model/tweet.dart';
import 'package:shut_up_and_tweet/model/user.dart';
import 'package:shut_up_and_tweet/ui/theme/colors.dart';

Widget adminPanel(
  UserData user,
  double size,
  List<Tweet> tweets,
  BuildContext context,
) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors().mediumTwitter,
      borderRadius: BorderRadius.circular(5.0),
    ),
    height: MediaQuery.of(context).size.height / 2.5,
    width: MediaQuery.of(context).size.width / size,
    child: Center(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: CachedNetworkImage(
                  imageUrl: user.profileImage,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  height: 50,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: GoogleFonts.roboto(
                        height: 1.5,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "@" + user.handle,
                      style: GoogleFonts.roboto(
                        height: 1.5,
                        color: AppColors().lightTwitter,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Followers: ${user.followers}",
                style: GoogleFonts.roboto(
                  height: 1.5,
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Tweet Count: ${user.statusCount}",
                style: GoogleFonts.roboto(
                  height: 1.5,
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height / 4,
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView.builder(
                itemCount: tweets.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors().darkTwitter,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Text(
                              tweets[index].tweet,
                              style: GoogleFonts.roboto(
                                height: 1.5,
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Retweets: ${tweets[index].retweetCount}",
                                  style: GoogleFonts.roboto(
                                    height: 1.5,
                                    color: AppColors().lightTwitter,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Likes: ${tweets[index].favoriteCount}",
                                  style: GoogleFonts.roboto(
                                    height: 1.5,
                                    color: AppColors().lightTwitter,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
