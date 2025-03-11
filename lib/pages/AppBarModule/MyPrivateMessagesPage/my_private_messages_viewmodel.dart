import 'dart:developer';

import 'package:dio/dio.dart';
import'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/constants/data_objects.dart';
import 'package:moto_kent/init/Helpers/local_storage.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/private_conversation_model.dart';
import 'package:moto_kent/services/api_service_impl.dart';
import 'package:moto_kent/services/iapi_service.dart';

class MyPrivateMessagesViewmodel extends ChangeNotifier{
  final IApiService _dio = ApiServiceImpl();
  final LocalStorage _localStorage=LocalStorageImpl();

  List<PrivateConversationModel> _list=[];
  List<PrivateConversationModel> get list=>_list;

  bool _isLoading=false;
  bool get isLoading=>_isLoading;
  
  Future<void> fetchPrivateConversation() async{
    _isLoading=false;
    notifyListeners();
    try{    String? user=await _localStorage.getValue<String>("user_id");
    var response=await _dio.getRequest(ApiConstants.getMyPrivateConversationByUserId(user!));
    if(response.statusCode==200){
      if(response.data is List){
        _list=(response.data as List).map((e) => PrivateConversationModel.fromJson(e)).toList();
      }
    }}catch(ex){
      log(ex.toString(),name:"fetchPrivateConversation");
    }
    _isLoading=true;
    notifyListeners();

  }

  Future<Response> startPrivateConversation(String userId2) async{
    String? userId=await LocalStorageImpl().getValue<String>("user_id");
    var response = await _dio.postRequest(ApiConstants.createPrivateConversation, DataObjects.privateConversationObject(userId!, userId2));
    return response;
  }
}