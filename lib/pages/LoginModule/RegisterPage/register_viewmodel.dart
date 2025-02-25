

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/services/api_service_impl.dart';

class RegisterViewmodel extends ChangeNotifier{
  final ApiServiceImpl _dio = ApiServiceImpl();
  bool _isCompleted=true;
  bool get isCompleted=>_isCompleted;


  Future<Response> registerRequest(Object object) async{
    try{
      _isCompleted=false;
      notifyListeners();
      var response = await _dio.postRequestWithoutToken(ApiConstants.registerEndpoint,object);
      _isCompleted=true;
      notifyListeners();
      return response;
    }catch(ex){
      _isCompleted=true;
      notifyListeners();
      throw Exception("Tekrar deneyiniz ");
    }
  }
}
