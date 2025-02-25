class UserModel {
  String? userId;
  String? fullName;
  String? profilePhotoPath;
  String? bio;
  int? rating;
  double? totalRating;
  int? followerCount;
  int? followingCount;
  List<String>? photos;

  UserModel(
      {this.userId,
        this.fullName,
        this.totalRating,
        this.profilePhotoPath,
        this.bio,
        this.rating,
        this.photos,
        this.followerCount,
        this.followingCount});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    fullName = json['fullName'];
    totalRating = double.tryParse(json['totalRating'].toString());
    photos = json['photos'].cast<String>()??[];
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
    data['totalRating'] = totalRating;
    data['photos'] = photos;
    data['profilePhotoPath'] = profilePhotoPath;
    data['bio'] = bio;
    data['rating'] = rating;
    data['followerCount'] = followerCount;
    data['followingCount'] = followingCount;
    return data;
  }
}
class UserModel2 {
  String? userId;
  String? fullName;
  String? profilePhotoPath;
  String? bio;
  int? rating;
  int? followerCount;
  int? followingCount;

  UserModel2(
      {this.userId,
        this.fullName,
        this.profilePhotoPath,
        this.bio,
        this.rating,
        this.followerCount,
        this.followingCount});

  UserModel2.fromJson(Map<String, dynamic> json) {
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
