class AppMarkerCoinPriceAndCountModel {
  int? appMarkerCoinCount;
  double? appMarkerCoinPrice;

  AppMarkerCoinPriceAndCountModel(
      {this.appMarkerCoinCount, this.appMarkerCoinPrice});

  AppMarkerCoinPriceAndCountModel.fromJson(Map<String, dynamic> json) {
    appMarkerCoinCount = json['appMarkerCoinCount'];
    appMarkerCoinPrice = json['appMarkerCoinPrice'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appMarkerCoinCount'] = appMarkerCoinCount;
    data['appMarkerCoinPrice'] = appMarkerCoinPrice;
    return data;
  }
}
