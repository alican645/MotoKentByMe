import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:moto_kent/constants/api_constants.dart";
import "package:moto_kent/services/dio_service_3.dart";




class LoginViewmodel extends ChangeNotifier{
  final DioService _dio = DioService();
  bool _isCompleted=true;
  bool get isCompleted=>_isCompleted;


  Future<Response> loginRequest (Object object) async{
    try{
      _isCompleted=false;
      false;
      notifyListeners();
      var result=await _dio.postRequestWithoutToken(ApiConstants.loginEndpoint, object);
      await Future.delayed(Duration(seconds: 3));
      _isCompleted=true;
      notifyListeners();
      return result;
    }catch(ex){
      _isCompleted=true;
      notifyListeners();
      throw Exception("Tekrar Deneyin");
    }
  }

  Future<Response> loginRequestWithSp(object) async {
    try{
      await Future.delayed(Duration(seconds: 3));
      var result=await _dio.postRequestWithoutToken(ApiConstants.loginEndpoint, object);
      return result;
    }catch(ex){
      throw Exception("Tekrar Deneyin");
    }
  }



}