
class LoginResponseModel {
  String? token;
  String? refreshToken;
  DateTime? expiration;
  String? userId;
  String? deviceToken;
  String? userFullName;
  String? bio;
  String? userProfilePhotoPath;
  int? totalNotificationCount;

  LoginResponseModel(
      {
        this.token, 
        this.refreshToken, 
        this.expiration, 
        this.userId,
        this.deviceToken,
        this.userFullName,
        this.bio,
        this.userProfilePhotoPath,
        this.totalNotificationCount});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    deviceToken = json['deviceToken'];
    bio = json['bio'];
    userProfilePhotoPath = json['userProfilePhotoPath'];
    userFullName= json['userFullName'];
    refreshToken = json['refreshToken'];
    expiration = DateTime.tryParse(json['expiration']);
    userId = json['userId'];
    totalNotificationCount = json['totalNotificationCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['deviceToken'] = deviceToken;
    data['bio'] = bio;
    data['userFullName'] = userFullName;
    data['userProfilePhotoPath'] = userProfilePhotoPath;
    data['refreshToken'] = refreshToken;
    data['expiration'] = expiration?.toIso8601String();
    data['userId'] = userId;
    data['totalNotificationCount'] = totalNotificationCount;
    return data;
  }
}