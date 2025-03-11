class ChangeEmailModel {
  String? userId;
  String? password;
  String? newEmail;
  String? token;

  ChangeEmailModel({this.userId, this.password, this.newEmail, this.token});

  ChangeEmailModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    password = json['password'];
    newEmail = json['newEmail'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['password'] = this.password;
    data['newEmail'] = this.newEmail;
    data['token'] = this.token;
    return data;
  }
}