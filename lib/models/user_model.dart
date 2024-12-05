class UserModel {
  String? userId;
  String? fullName;
  String? profilePhotoPath;
  String? bio;
  int? rating;
  int? followerCount;
  int? followingCount;

  UserModel(
      {this.userId,
        this.fullName,
        this.profilePhotoPath,
        this.bio,
        this.rating,
        this.followerCount,
        this.followingCount});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    fullName = json['fullName'];
    profilePhotoPath = json['profilePhotoPath'];
    bio = json['bio'];
    rating = json['rating'];
    followerCount = json['followerCount'];
    followingCount = json['followingCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['fullName'] = fullName;
    data['profilePhotoPath'] = profilePhotoPath;
    data['bio'] = bio;
    data['rating'] = rating;
    data['followerCount'] = followerCount;
    data['followingCount'] = followingCount;
    return data;
  }
}
