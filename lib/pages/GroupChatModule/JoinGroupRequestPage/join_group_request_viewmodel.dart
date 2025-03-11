import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/user_model.dart';
import 'package:moto_kent/services/api_service_impl.dart';

class JoinGroupRequestViewmodel extends ChangeNotifier{
  List<UserModel> _list=[];
  List<UserModel> get list=>_list;

  bool _isLoading=false;
  bool get isLoading=>_isLoading;

  ApiServiceImpl apiService = ApiServiceImpl();
Future<void> fetchList(int groupId,bool isRefresh) async {
  isRefresh==true? {
  _isLoading=false,
  notifyListeners()
  }:{

  };
  var response= await apiService.getRequest(ApiConstants.getAllJoinRequestByGroupId(groupId));
  if(response.data is List){
    _list= (response.data as List).map((e) => UserModel.fromJson(e),).toList();

  }
  isRefresh==true? {
    _isLoading=true,
    notifyListeners()
  }:{
    notifyListeners()
  };
}

Future<Response> acceptOrReject(int groupId,Object data) async {
  var response=await apiService.postRequest(ApiConstants.acceptGroupJoinRequest, data);
  fetchList(groupId, false);
  return response;

}



}