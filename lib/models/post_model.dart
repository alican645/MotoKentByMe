import 'package:moto_kent/models/post_category_model.dart';
import 'package:moto_kent/models/user_model.dart';

class PostModel {
  int? id;
  String? userId;
  String? userPhotoPath;
  String? userFullName;
  String? postContentTitle;
  String? postContent;
  String? postCategoryIconPath;
  String? postCategoryName;
  DateTime? postDate;
  String? postLocation;
  int? postCategoryId;
  int? likes;
  int? dislikes;
  int? quotedPostId;


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
      this.userPhotoPath,
      this.userFullName,
      this.postCategoryIconPath,
      this.postCategoryName,

      this.quotedPostId});

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    quotedPostId = json['quotedPostId'];
    likes = json['likes'];
    dislikes = json['dislikes'];
    userFullName = json['userFullName'];
    userPhotoPath = json['userPhotoPath'];

    postContentTitle = json['postContentTitle'];
    postContent = json['postContent'];
    postDate = DateTime.tryParse(json['postDate']);
    postLocation = json['postLocation'];
    postCategoryId = json['postCategoryId'];
    postCategoryIconPath = json['postCategoryIconPath'];
    postCategoryName = json['postCategoryName'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['quotedPostId'] = quotedPostId;
    data['likes'] = likes;
    data['dislikes'] = dislikes;
    data['userFullName'] = userFullName;
    data['userPhotoPath'] = userPhotoPath;
    data['id'] = id;

    data['postContentTitle'] = postContentTitle;
    data['postContent'] = postContent;
    data['postDate'] = postDate?.toIso8601String();
    data['postLocation'] = postLocation;
    data['postCategoryId'] = postCategoryId;
    data['postCategoryIconPath'] = postCategoryIconPath;
    data['postCategoryName'] = postCategoryName;

    return data;
  }
}
