class UserPhotosModel {
  bool? isSuccess;
  String? message;
  List<String>? photoPaths;

  UserPhotosModel({this.isSuccess, this.message, this.photoPaths});

  UserPhotosModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    photoPaths = json['photoPaths'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    data['message'] = message;
    data['photoPaths'] = photoPaths;
    return data;
  }
}