

import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/about_item_model.dart';
import 'package:moto_kent/models/about_title_model.dart';

import 'package:moto_kent/services/api_service_impl.dart';
import 'package:moto_kent/services/iapi_service.dart';

class AboutViewmodel extends ChangeNotifier{
  IApiService apiService = ApiServiceImpl();

  List<AboutTitleModel> _list=[];
  List<AboutTitleModel> get list=>_list;

  bool _isLoading=false;
  bool get islLoading=>_isLoading;

  
  Future<void> fetchAbouts() async{
    _isLoading=false;
    notifyListeners();
    try{
      var response =await apiService.getRequest(ApiConstants.getAbouts);
      if(response.statusCode==200){
        if(response.data is List){
          _list=(response.data as List).map((e) =>AboutTitleModel.fromJson(e) ,).toList();
        }
      }
      _isLoading=true;
      notifyListeners();
    }catch(ex){
      rethrow;
    }
  }
}