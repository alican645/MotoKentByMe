class UserSearchItemModel {
  String? id;
  String? fullName;
  String? profilePhotoPath;

  UserSearchItemModel({this.id, this.fullName, this.profilePhotoPath});

  UserSearchItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    profilePhotoPath = json['profilePhotoPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullName'] = fullName;
    data['profilePhotoPath'] = profilePhotoPath;
    return data;
  }
}