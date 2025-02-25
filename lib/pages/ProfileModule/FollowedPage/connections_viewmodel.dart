import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/local_storage.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/connection_model.dart';
import 'package:moto_kent/services/api_service_impl.dart';

class ConnectionsViewmodel extends ChangeNotifier{
  final ApiServiceImpl _dio = ApiServiceImpl();
  final LocalStorage _localStorage=LocalStorageImpl();

  List<ConnectionModel> _followerList=[];
  List<ConnectionModel> get followerList=>_followerList;

  int? _followerCount;
  int? get followerCount=>_followerCount;

  List<ConnectionModel> _followedList=[];
  List<ConnectionModel> get followedList=>_followedList;

  int? _followedCount;
  int? get followedCount=>_followedCount;

  bool _isLoading=false;
  bool get isLoading=>_isLoading;

  Future<void> fetchConnections() async{
    _isLoading=false;
    notifyListeners();
    String? userId= await _localStorage.getValue<String>("user_id");
    try{
      var response = await _dio.getRequest(ApiConstants.getUserConnections(userId!));

      if(response.statusCode==200){
        _followerList=((response.data as Map<String,dynamic>)["userFollowerDtos"] as List).map((e) => ConnectionModel.fromJson(e),).toList();
        _followerCount=_followerList.length;
        _followedList=((response.data as Map<String,dynamic>)["userFollowedDtos"] as List).map((e) => ConnectionModel.fromJson(e),).toList();
        _followedCount=_followedList.length;
        _isLoading=true;
        notifyListeners();
      }
    }catch(e){
      log(e.toString(),name: "Bağlantı Çekilme İşlemi");
    }
  }

  Future<Response> followOrUnfollowUser(String followedId, bool isFollow) async {
    String? userId= await _localStorage.getValue<String>("user_id");
    Object object= {
      "followerId": userId,
      "followedUserId": followedId,
      };
    String endpoint =
    isFollow ? ApiConstants.followEndpoint : ApiConstants.unfollowEndpoint;
    var response = await _dio.postRequest(endpoint, object);
    return response;
  }

  Future<bool> followUser(String followedId) async{

    try{
      String? userId= await _localStorage.getValue<String>("user_id");
      Object object= {
        "followerId": userId,
        "followedUserId": followedId,
      };
      var response = await _dio.postRequest(ApiConstants.followEndpoint, object);
      if(response.statusCode==200){
        var user = ConnectionModel.fromJson(response.data as Map<String,dynamic>);
        _followedList.add(user);
        _followerList.firstWhere((element) => element.userId==(object as Map<String,dynamic>)["followedUserId"]).isFollowing=true;
        _followedCount=followedList.length;
        _followerCount=_followerList.length;
        notifyListeners();
        return true;
      }
      return false;
    }catch(ex){
      return false;
    }

  }

  Future<bool> unfollowUser(String followedId,int index) async{

    try{
      String? userId= await _localStorage.getValue<String>("user_id");
      Object object= {
        "followerId": userId,
        "followedUserId": followedId,
      };

      var response = await _dio.postRequest(ApiConstants.unfollowEndpoint, object);
      if(response.statusCode==200){

        _followerList.firstWhere((element) => element.userId==(object as Map<String,dynamic>)["followedUserId"]).isFollowing=false;
        _followedList.removeWhere((element) => element.userId==(object as Map<String,dynamic>)["followedUserId"] );
        _followedCount=followedList.length;
        _followerCount=_followerList.length;
        notifyListeners();
        return true;
      }
      return false;
    }catch(ex){
      return false;
    }
  }





}