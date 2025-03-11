

import 'package:flutter/cupertino.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/services/api_service_impl.dart';
import 'package:moto_kent/services/iapi_service.dart';

class ChangePasswordViewmodel extends ChangeNotifier{
  final IApiService _apiService=ApiServiceImpl();


  Future<bool> changePasword(Object object) async{
    try{
      var response =await _apiService.postRequest(ApiConstants.changePassword,object);
      if(response.statusCode==200||response.statusCode==201){
        return true;
      }else{
        return false;
      }
    }catch(ex){
      return false;
    }
  }
}

