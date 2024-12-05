import 'package:moto_kent/models/post_category_model.dart';
import 'package:moto_kent/models/user_model.dart';

class PostModel {
  int? id;
  String? userId;
  UserModel? user;
  String? userPhotoPath;
  String? userFullName;
  String? postContentTitle;
  String? postContent;
  String? postCategoryIconPath;
  String? postCategoryName;
  DateTime? postDate;
  String? postLocation;
  int? postCategoryId;
  PostCategoryModel? postCategory;

  PostModel(
      {this.userId,
        this.id,
        this.user,
        this.postContentTitle,
        this.postContent,
        this.postDate,
        this.postLocation,
        this.postCategoryId,
        this.userPhotoPath,
        this.userFullName,
        this.postCategoryIconPath,
        this.postCategoryName,
        this.postCategory});

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    userFullName = json['userFullName'];
    userPhotoPath = json['userPhotoPath'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    postContentTitle = json['postContentTitle'];
    postContent = json['postContent'];
    postDate = DateTime.tryParse(json['postDate']);
    postLocation = json['postLocation'];
    postCategoryId = json['postCategoryId'];
    postCategoryIconPath = json['postCategoryIconPath'];
    postCategoryName = json['postCategoryName'];
    postCategory = json['postCategory'] != null
        ? PostCategoryModel.fromJson(json['postCategory'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['userFullName'] = userFullName;
    data['userPhotoPath'] = userPhotoPath;
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['postContentTitle'] = postContentTitle;
    data['postContent'] = postContent;
    data['postDate'] = postDate?.toIso8601String();
    data['postLocation'] = postLocation;
    data['postCategoryId'] = postCategoryId;
    data['postCategoryIconPath'] = postCategoryIconPath;
    data['postCategoryName'] = postCategoryName;
    if (postCategory != null) {
      data['postCategory'] = postCategory!.toJson();
    }
    return data;
  }
}


