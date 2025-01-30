class BannerModel {
  int? id;
  String? bannerName;
  String? photoPath;
  String? navigatePath;
  bool? isCurrentBanner;
  bool? isDeleted;

  BannerModel(
      {this.id,
        this.bannerName,
        this.photoPath,
        this.navigatePath,
        this.isCurrentBanner,
        this.isDeleted});

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bannerName = json['bannerName'];
    photoPath = json['photoPath'];
    navigatePath = json['navigatePath'];
    isCurrentBanner = json['isCurrentBanner'];
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['bannerName'] = bannerName;
    data['photoPath'] = photoPath;
    data['navigatePath'] = navigatePath;
    data['isCurrentBanner'] = isCurrentBanner;
    data['isDeleted'] = isDeleted;
    return data;
  }
}