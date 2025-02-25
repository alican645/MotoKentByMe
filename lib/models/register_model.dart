class RegisterModel {
  String? fullName;
  DateTime? birthDate;
  bool? gender;
  String? email;
  String? password;
  String? confirmPassword;

  RegisterModel(
      {this.fullName,
      this.birthDate,
      this.email,
        this.gender,
      this.password,
      this.confirmPassword});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    gender = json['gender'];
    birthDate = DateTime.tryParse(json['birthDate']);
    email = json['email'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['gender'] = gender;
    data['birthDate'] = birthDate?.toIso8601String();
    data['email'] = email;
    data['password'] = password;
    data['confirmPassword'] = confirmPassword;
    return data;
  }
}
