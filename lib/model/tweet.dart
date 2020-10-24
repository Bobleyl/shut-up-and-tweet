class Tweet {
  final String tweet;
  final int retweetCount;
  final int favoriteCount;

  Tweet(
    this.tweet,
    this.retweetCount,
    this.favoriteCount,
  );

  factory Tweet.fromJson(Map<String, dynamic> json) {
    return Tweet(
      json['full_text'].toString(),
      json['retweet_count'],
      json['favorite_count'],
    );
  }
}
