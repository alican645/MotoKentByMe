import 'dart:convert';
import 'dart:typed_data';

class LocationModel {
  int? id;                    // Veritabanı ID
  double? latitude;           // Enlem
  double? longitude;          // Boylam
  String? iconPath;           // İkon yolu
  String? markerId;           // Marker ID
  String? userId;             // Kullanıcı ID (Guid'in karşılığı String)
  DateTime? createdDate;      // Oluşturulma tarihi

  /*
  {
  "latitude": 0,
  "longitude": 0,
  "iconPath": "string",
  "markerId": "string",
  "imageBytes": "string",
  "userId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "createdDate": "2024-12-12T13:23:01.337Z"
}

  * */

  LocationModel({
    this.id,
    this.latitude,
    this.longitude,
    this.iconPath,
    this.markerId,
    this.userId,
    this.createdDate,
  });

  /// JSON'dan Model Nesnesi Oluşturma
  LocationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['iconPath'] = iconPath;
    data['markerId'] = markerId;
    data['userId'] = userId;
    data['createdDate'] = createdDate?.toIso8601String();

    return data;
  }
}

