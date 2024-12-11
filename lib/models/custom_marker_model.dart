class CustomMarkerModel {
  int? id;
  String? iconPath;
  String? uploadedDate;
  String? iconName;
  int? price;

  CustomMarkerModel(
      {this.id, this.iconPath, this.uploadedDate, this.iconName, this.price});

  CustomMarkerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    iconPath = json['iconPath'];
    uploadedDate = json['uploadedDate'];
    iconName = json['iconName'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['iconPath'] = iconPath;
    data['uploadedDate'] = uploadedDate;
    data['iconName'] = iconName;
    data['price'] = price;
    return data;
  }
}