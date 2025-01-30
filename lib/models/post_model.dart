import 'package:moto_kent/models/user_model.dart';

class PostModel {
  int? id;
  String? userId;
  String? userProfilePhotoPath;
  String? userFullName;
  String? postContentTitle;
  String? postContent;
  String? postCategoryPhotoPath;
  String? postCategoryCategoryName;
  bool?isOriginalPost;
  DateTime? postDate;
  String? postLocation;
  int? postCategoryId;
  int? likes;
  int? dislikes;
  int?commentCount;
  bool? isMyFavorite;

  String? sharedUserId;
  String? sharedUserFullName;

  PostModel(
      {this.userId,
      this.id,
      this.likes,
      this.dislikes,
      this.postContentTitle,
      this.postContent,
      this.postDate,
      this.postLocation,
      this.postCategoryId,
      this.userProfilePhotoPath,
      this.userFullName,
      this.isOriginalPost,
      this.postCategoryPhotoPath,
      this.postCategoryCategoryName,
      this.isMyFavorite,
      this.sharedUserId,
      this.sharedUserFullName,this.commentCount});

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    isOriginalPost = json['isOriginalPost'];
    isMyFavorite = json['isMyFavorite'];
    sharedUserId = json['sharedUserId'];
    sharedUserFullName = json['sharedUserFullName'];
    likes = json['likes'];
    dislikes = json['dislikes'];
    commentCount = json['commentCount'];
    userFullName = json['userFullName'];
    userProfilePhotoPath = json['userProfilePhotoPath'];
    postContentTitle = json['postContentTitle'];
    postContent = json['postContent'];
    postDate = DateTime.tryParse(json['postDate']);
    postLocation = json['postLocation'];
    postCategoryId = json['postCategoryId'];
    postCategoryPhotoPath = json['postCategoryPhotoPath'];
    postCategoryCategoryName = json['postCategoryCategoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['isMyFavorite'] = isMyFavorite;
    data['isOriginalPost'] = isOriginalPost;
    data['sharedUserId'] = sharedUserId;
    data['sharedUserFullName'] = sharedUserFullName;
    data['likes'] = likes;
    data['dislikes'] = dislikes;
    data['commentCount'] = commentCount;
    data['userFullName'] = userFullName;
    data['userProfilePhotoPath'] = userProfilePhotoPath;
    data['id'] = id;
    data['postContentTitle'] = postContentTitle;
    data['postContent'] = postContent;
    data['postDate'] = postDate?.toIso8601String();
    data['postLocation'] = postLocation;
    data['postCategoryId'] = postCategoryId;
    data['postCategoryPhotoPath'] = postCategoryPhotoPath;
    data['postCategoryCategoryName'] = postCategoryCategoryName;

    return data;
  }
}
