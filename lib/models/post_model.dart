class PostModel {
  int? id;
  String? userId;
  String? postContentTitle;
  String? postContent;
  String? userFullName;
  String? userProfilePhotoPath;
  DateTime? createdDate;
  int? illerEnum;
  int? postCategoryEnum;
  int? likes;
  int? commentCount;
  double?totalRating;
  int? dislikes;
  int? votedSurveyItemId;
  bool? isMyFavorite;

  List<SurveyItems>? surveyItems;

  PostModel(
      {this.id,
      this.userId,
      this.postContentTitle,
      this.postContent,
      this.totalRating,

      this.createdDate,
      this.votedSurveyItemId,
      this.illerEnum,
      this.postCategoryEnum,
      this.surveyItems,
      this.userProfilePhotoPath,
      this.isMyFavorite,
      this.likes,
      this.commentCount,
      this.dislikes,
      this.userFullName,
      });

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    totalRating = double.tryParse(json['totalRating'].toString());
    votedSurveyItemId = json['votedSurveyItemId'];
    userFullName = json['userFullName'];

    likes = json['likes'];
    dislikes = json['dislikes'];
    commentCount = json['commentCount'];
    postContentTitle = json['postContentTitle'];
    isMyFavorite = json['isMyFavorite'];
    userProfilePhotoPath = json['userProfilePhotoPath'];
    postContent = json['postContent'];
    createdDate = DateTime.parse(json['createdDate']);
    illerEnum = json['illerEnum'];
    postCategoryEnum = json['postCategoryEnum'];
    if (json['surveyItems'] != null) {
      surveyItems = <SurveyItems>[];
      json['surveyItems'].forEach((v) {
        surveyItems!.add(SurveyItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['likes'] = likes;
    data['totalRating'] = totalRating;
    data['votedSurveyItemId'] = votedSurveyItemId;
    data['dislikes'] = dislikes;
    data['userFullName'] = userFullName;
    data['commentCount'] = commentCount;
    data['isMyFavorite'] = isMyFavorite;
    data['userProfilePhotoPath'] = userProfilePhotoPath;
    data['postContentTitle'] = postContentTitle;
    data['postContent'] = postContent;
    data['illerEnum'] = illerEnum;
    data['postCategoryEnum'] = postCategoryEnum;
    if (surveyItems != null) {
      data['surveyItems'] = surveyItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SurveyItems {
  int? id;
  int? voteCount;
  String? content;

  SurveyItems({
    this.content,
  this.id,
  this.voteCount,
  
  });

  SurveyItems.fromJson(Map<String, dynamic> json) {
    id=json['id'];
    content = json['content'];
    voteCount = json['voteCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id']=id;
    data['content'] = content;
    data['voteCount'] = voteCount;
    return data;
  }
}
