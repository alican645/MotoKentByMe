class LastLocationModel {
  int? id;
  String? userId;
  DateTime? createdDate;
  double? lat;
  double? lng;

  LastLocationModel(
      {this.id, this.userId, this.createdDate, this.lat, this.lng});

  LastLocationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    createdDate = DateTime.tryParse(json['createdDate']);
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['createdDate'] = createdDate?.toIso8601String();
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}