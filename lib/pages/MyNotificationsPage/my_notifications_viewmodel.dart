import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/models/notification_model.dart';
import 'package:moto_kent/services/dio_service_3.dart';

class MyNotificationsViewmodel extends ChangeNotifier{

  List<NotificationModel> _list=[];
  List<NotificationModel> get list=>_list;

  bool _isLoading=false;
  bool get isLoading=>_isLoading;

  final DioService _dioService=DioService();





  Future<void> fetchList(bool isRefresh) async {
  isRefresh==true? {
  _isLoading=false,
  notifyListeners()
  }:{

  };
  String? userId=await SharedPreferencesHelper().getValue<String>("user_id");
    var response=await  _dioService.getRequest(ApiConstants.getAllNotificationByAdminId(userId!));
    if(response.data is List){
      _list=(response.data as List).map((e) => NotificationModel.fromJson(e),).toList();
    }
  isRefresh==true? {
    _isLoading=true,
    notifyListeners()
  }:{
    notifyListeners()
  };
}



  Future<Response> acceptOrReject(Object data) async {
  var response=await _dioService.postRequest(ApiConstants.acceptGroupJoinRequest, data);
  fetchList(false);
  return response;

}
}