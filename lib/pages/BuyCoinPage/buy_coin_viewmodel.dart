import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/app_marker_coin_price_and_count_model.dart';
import 'package:moto_kent/services/api_service.dart';
import 'package:moto_kent/services/dio_service_3.dart';

class BuyCoinViewmodel extends ChangeNotifier {
  DioService _dio = DioService();
  List<AppMarkerCoinPriceAndCountModel> _list = [];
  List<AppMarkerCoinPriceAndCountModel> get list => _list;

  Future<List<AppMarkerCoinPriceAndCountModel>> getAppMarkerCoinPriceAndCountList() async {
    try{
      var response =
      await _dio.getRequest(ApiConstants.getAppMarkerCoinPriceAndCountList);
      if (response.statusCode == 200) {
        if (response.data is List) {

          _list = (response.data as List)
              .map(
                (item) => AppMarkerCoinPriceAndCountModel.fromJson(item),
          )
              .toList();
          return _list;
        }
      }
      throw Exception("Veri Çekilemedi");
    } catch(exception){
      log(exception.toString(),name: "BuyCoinPage");
      throw exception;
    }
  }
}
