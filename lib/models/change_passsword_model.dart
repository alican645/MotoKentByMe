class ChangePasswordModel {
  String? userId;
  String? oldPassword;
  String? newPassword;

  ChangePasswordModel({this.userId, this.oldPassword, this.newPassword});

  ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    oldPassword = json['oldPassword'];
    newPassword = json['newPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['oldPassword'] = this.oldPassword;
    data['newPassword'] = this.newPassword;
    return data;
  }
}