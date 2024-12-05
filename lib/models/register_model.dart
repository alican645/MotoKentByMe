class RegisterModel {
  String? fullName;
  String? email;
  String? password;
  String? confirmPassword;

  RegisterModel(
      {this.fullName, this.email, this.password, this.confirmPassword});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    email = json['email'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['email'] = email;
    data['password'] = password;
    data['confirmPassword'] = confirmPassword;
    return data;
  }
}
