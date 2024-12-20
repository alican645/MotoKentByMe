import 'package:moto_kent/constants/enums.dart';

class CallForHelpModel {
  int? id;
  String? userId;
  DateTime? createdDate;
  double? lat;
  double? lng;
  CallForHelpEnum? callForHelpEnum;

  CallForHelpModel(
      {this.id, this.userId, this.createdDate, this.lat, this.lng, this.callForHelpEnum});

  // JSON'dan Model'e Dönüşüm
  CallForHelpModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    callForHelpEnum = _intToEnum(json['callForHelpEnum']);
    createdDate = DateTime.tryParse(json['createdDate'] ?? '');
    lat = json['lat'];
    lng = json['lng'];
  }

  // Model'den JSON'a Dönüşüm
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['callForHelpEnum'] = _enumToInt(callForHelpEnum);
    data['createdDate'] = createdDate?.toIso8601String();
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }

  // Enum'dan Int'e Dönüşüm
  int? _enumToInt(CallForHelpEnum? enumValue) {
    return enumValue?.index; // Enum'un index'ini döner
  }

  // Int'ten Enum'a Dönüşüm
  CallForHelpEnum? _intToEnum(int? value) {
    if (value == null) return null;
    return CallForHelpEnum.values[value];
  }
}
