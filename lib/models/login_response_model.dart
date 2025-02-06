
class LoginResponseModel {
  String? token;
  String? refreshToken;
  DateTime? expiration;
  String? userId;
  String? deviceToken;
  int? totalNotificationCount;

  LoginResponseModel(
      {
        this.token, 
        this.refreshToken, 
        this.expiration, 
        this.userId,
        this.deviceToken,
        this.totalNotificationCount});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    deviceToken = json['deviceToken'];
    refreshToken = json['refreshToken'];
    expiration = DateTime.tryParse(json['expiration']);
    userId = json['userId'];
    totalNotificationCount = json['totalNotificationCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['deviceToken'] = deviceToken;
    data['refreshToken'] = refreshToken;
    data['expiration'] = expiration?.toIso8601String();
    data['userId'] = userId;
    data['totalNotificationCount'] = totalNotificationCount;
    return data;
  }
}