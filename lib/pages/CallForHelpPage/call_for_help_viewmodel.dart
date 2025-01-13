import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/constants/enums.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/models/call_for_help_model.dart';
import 'package:moto_kent/services/dio_service_3.dart';

class CallForHelpViewmodel extends ChangeNotifier {
  final _dio = DioService();

  bool _isLoadingSY = true;
  bool get isLoadingSY => _isLoadingSY;

  bool _isLoadingKY = true;
  bool get isLoadingKY => _isLoadingKY;

  bool _isLoadingBB = true;
  bool get isLoadingBB => _isLoadingBB;

  int _userCount = 0;
  int get userCount => _userCount;

  Future<Response> sendCallForHelp(CallForHelpEnum callForEnum) async {
    if (callForEnum == CallForHelpEnum.beniBul) {
      _isLoadingBB = false;
    } else if (callForEnum == CallForHelpEnum.sorunYardim) {
      _isLoadingSY = false;
    } else {
      _isLoadingKY = false;
    }
    notifyListeners();
    String? userId =await SharedPreferencesHelper().getValue<String>("user_id");
    double? latitude =await SharedPreferencesHelper().getValue<double>("last_location_latidue");
    double? longitude =await SharedPreferencesHelper().getValue<double>("last_location_longitude");
    //print('Anlık Konum: ${position.latitude}, ${position.longitude}');
    var callForHelpModel = CallForHelpModel(
        userId: userId,
        lat: latitude,
        lng: longitude,
        callForHelpEnum: callForEnum);
    try {
      var response = await _dio.postRequest(
          ApiConstants.sendCallForHelp, callForHelpModel.toJson());
      if (response.statusCode == 200) {
        if (callForEnum == CallForHelpEnum.beniBul) {
          _isLoadingBB = true;
        } else if (callForEnum == CallForHelpEnum.sorunYardim) {
          _isLoadingSY = true;
        } else {
          _isLoadingKY = true;
        }

        notifyListeners();
        return response;
      }
    } catch (e) {
      throw Exception(e);
    }

    throw Exception();
  }
}
