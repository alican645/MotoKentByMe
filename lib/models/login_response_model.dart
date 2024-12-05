
class LoginResponseModel {
  String? token;
  String? refreshToken;
  DateTime? expiration;
  String? userId;

  LoginResponseModel(
      {this.token, this.refreshToken, this.expiration, this.userId});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    refreshToken = json['refreshToken'];
    expiration = DateTime.tryParse(json['expiration']);
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['refreshToken'] = refreshToken;
    data['expiration'] = expiration?.toIso8601String();
    data['userId'] = userId;
    return data;
  }
}