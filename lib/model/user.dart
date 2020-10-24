class UserData {
  final String profileImage;
  final int followers;
  final int following;
  final String name;
  final String handle;
  final int statusCount;
  final int favouriteCount;

  UserData(
    this.profileImage,
    this.followers,
    this.following,
    this.name,
    this.handle,
    this.statusCount,
    this.favouriteCount,
  );

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      json['profile_image_url'].toString(),
      json['followers_count'],
      json['friends_count'],
      json['name'].toString(),
      json['screen_name'].toString(),
      json['statuses_count'],
      json['favourites_count'],
    );
  }
}
