class UserRatingModel {
  String? targetUserId;
  String? raterUserId;
  int? rating;

  UserRatingModel({this.targetUserId, this.raterUserId, this.rating});

  UserRatingModel.fromJson(Map<String, dynamic> json) {
    targetUserId = json['targetUserId'];
    raterUserId = json['raterUserId'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['targetUserId'] = this.targetUserId;
    data['raterUserId'] = this.raterUserId;
    data['rating'] = this.rating;
    return data;
  }
}