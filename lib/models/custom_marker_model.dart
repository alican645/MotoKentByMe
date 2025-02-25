class CustomMarkerModel {
  int? id;
  String? iconPath;
  DateTime? uploadedDate;
  String? iconName;
  int? price;

  CustomMarkerModel(
      {this.id, this.iconPath, this.uploadedDate, this.iconName, this.price});

  CustomMarkerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    iconPath = json['iconPath'];
    uploadedDate = DateTime.tryParse(json['uploadedDate']);
    iconName = json['iconName'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['iconPath'] = iconPath;
    data['uploadedDate'] = uploadedDate!.toIso8601String();
    data['iconName'] = iconName;
    data['price'] = price;
    return data;
  }
}