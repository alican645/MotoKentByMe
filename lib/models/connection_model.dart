class ConnectionModel {
  String? userId;
  String? fullName;
  String? profilePhotoPath;
  bool? isFollowing;

  ConnectionModel(
      {this.userId, this.fullName, this.profilePhotoPath, this.isFollowing});

  ConnectionModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    fullName = json['fullName'];
    profilePhotoPath = json['profilePhotoPath'];
    isFollowing = json['isFollowing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['fullName'] = this.fullName;
    data['profilePhotoPath'] = this.profilePhotoPath;
    data['isFollowing'] = this.isFollowing;
    return data;
  }
}