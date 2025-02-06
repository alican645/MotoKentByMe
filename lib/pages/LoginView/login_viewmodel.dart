import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:moto_kent/constants/api_constants.dart";
import "package:moto_kent/init/Helpers/shared_preferences_helper.dart";
import "package:moto_kent/models/login_response_model.dart";
import "package:moto_kent/services/dio_service_3.dart";




class LoginViewmodel extends ChangeNotifier{
  final DioService _dio = DioService();
  bool _isCompleted=true;
  bool get isCompleted=>_isCompleted;
  
  int _notificationCount=0;
  int get notificationCount =>_notificationCount;

  void set0NotificationCount(){
    _notificationCount=0;
    notifyListeners();
  }


  Future<Response> loginRequest (Object object) async{
    try{
      _isCompleted=false;
      false;
      notifyListeners();
      var result=await _dio.postRequestWithoutToken(ApiConstants.loginEndpoint, object);
      if(result.statusCode==200){
        var loginResponseData = LoginResponseModel.fromJson(result.data);
        String token = loginResponseData.token!;
        String refreshToken = loginResponseData.refreshToken!;
        String expiration = loginResponseData.expiration!.toString();
        String userId = loginResponseData.userId!; // Kullanıcı ID'sini aldık
        _notificationCount=0;
        await SharedPreferencesHelper()
          .setValue<String>('jwt_token', token);
        await SharedPreferencesHelper()
            .setValue<String>('refresh_token', refreshToken);
        await SharedPreferencesHelper()
            .setValue<String>('token_expiration', expiration);
        await SharedPreferencesHelper()
            .setValue<String>('user_id', userId); // Kullanıcı ID'sini kaydettik
      }
      await Future.delayed(Duration(seconds: 3));
      _isCompleted=true;
      notifyListeners();
      return result;
    }catch(ex){
      _isCompleted=true;
      notifyListeners();
      throw Exception(ex);
    }
  }





}