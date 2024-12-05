class PostCategoryModel {
  int? id;
  String? name;
  String? iconPath;

  PostCategoryModel({this.id, this.name, this.iconPath});

  PostCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    iconPath = json['iconPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['iconPath'] = iconPath;
    return data;
  }
}