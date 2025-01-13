
class LocationModel {
  int? id;
  int? iconPrice;
  double? latitude;
  double? longitude;
  String? iconPath;
  String? markerId;
  String? userId;
  DateTime? createdDate;



  LocationModel({
    this.id,
    this.latitude,
    this.longitude,
    this.iconPath,
    this.markerId,
    this.userId,
    this.createdDate,
    this.iconPrice
  });

  /// JSON'dan Model Nesnesi Oluşturma
  LocationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    iconPrice = json['iconPrice'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    iconPath = json['iconPath'];
    markerId = json['markerId'];
    userId = json['userId'];
    createdDate = json['createdDate'] != null
        ? DateTime.tryParse(json['createdDate'])
        : null;

  }

  /// Model Nesnesini JSON'a Dönüştürme
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['iconPrice'] = iconPrice;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['iconPath'] = iconPath;
    data['markerId'] = markerId;
    data['userId'] = userId;
    data['createdDate'] = createdDate?.toIso8601String();

    return data;
  }
}

