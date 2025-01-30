class PostCommentModel {
  int? id;
  int? postId;
  String? userId;
  String? content;
  String? userProfilePhotoPath;
  String? userFullName;

  PostCommentModel(
      {this.userId,this.id,this.content,this.postId,this.userProfilePhotoPath,this.userFullName});

  PostCommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['postId'];
    userId = json['userId'];
    content = json['content'];
    userProfilePhotoPath = json['userProfilePhotoPath'];
    userFullName = json['userFullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['postId'] = postId;
    data['userId'] = userId;
    data['content'] = content;
    data['userProfilePhotoPath'] = userProfilePhotoPath;
    data['userFullName'] = userFullName;
    return data;
  }
}
