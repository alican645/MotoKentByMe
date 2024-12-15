import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/last_location_model.dart';
import 'package:moto_kent/services/dio_service_3.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallForHelpViewmodel extends ChangeNotifier{
  DioService _dio = DioService();

  Future<void> callForHelp() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId= prefs.getString("user_id");
    double? latitude=prefs.getDouble("last_location_latidue");
    double? longitude=prefs.getDouble("last_location_longitude");
    //print('Anlık Konum: ${position.latitude}, ${position.longitude}');
    var lastLocation = LastLocationModel(
        userId: userId,
        lat: latitude,
        lng: longitude
    );
    await _dio.postRequest(ApiConstants.getNearbyUsers, lastLocation.toJson());

  }
}