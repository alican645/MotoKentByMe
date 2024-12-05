import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:moto_kent/constants/api_constants.dart";
import "package:moto_kent/services/dio_service_3.dart";




class LoginViewmodel extends ChangeNotifier{
  final DioService3 _dio = DioService3();
  bool _isCompleted=false;
  bool get isCompleted=>_isCompleted;


  Future<Response> loginRequest (Object object) async{
    _isCompleted=false;
    false;
    notifyListeners();
    var result=await _dio.postRequestWithoutToken(ApiConstants.loginEndpoint, object);
    _isCompleted=true;
    notifyListeners();
    return result;
  }



}