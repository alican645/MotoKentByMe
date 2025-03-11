import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:moto_kent/constants/api_constants.dart";
import "package:moto_kent/init/Helpers/local_storage.dart";
import "package:moto_kent/init/Helpers/local_storage_impl.dart";
import "package:moto_kent/models/login_response_model.dart";
import "package:moto_kent/services/api_service_impl.dart";




class LoginViewmodel extends ChangeNotifier{

  final ApiServiceImpl _dio = ApiServiceImpl();
  final LocalStorage _localStorage = LocalStorageImpl();
  bool _isCompleted=true;
  bool get isCompleted=>_isCompleted;

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
        String userFullName = loginResponseData.userFullName!; // Kullanıcı ID'sini aldık
        String userProfilePhotoPath = loginResponseData.userProfilePhotoPath!; // Kullanıcı ID'sini aldık
        String? bio = loginResponseData.bio; // Kullanıcı ID'sini aldık

        await _localStorage
          .setValue<String>('jwt_token', token);
        await _localStorage
            .setValue<String>('refresh_token', refreshToken);
        await _localStorage
            .setValue<String>('token_expiration', expiration);
        await _localStorage
            .setValue<String>('user_id', userId); // Kullanıcı ID'sini kaydettik
        await _localStorage.setValue<String>("user_full_name", userFullName);
        await _localStorage.setValue<String>("user_profile_photo_path", userProfilePhotoPath);
        await _localStorage.setValue<String?>("user_bio", bio);
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