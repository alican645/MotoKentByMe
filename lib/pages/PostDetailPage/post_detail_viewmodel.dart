


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/post_model.dart';
import 'package:moto_kent/services/dio_service_3.dart';


class PostDetailViewmodel extends ChangeNotifier{
  PostModel? _postModel;
  PostModel? get postModel=>_postModel;
  DioService _dio=DioService();

  // post detay ekranı ilk yüklendiğinde
  Future<void> getPostByPostId(int postId) async {
    _postModel=null;
    notifyListeners();
    var response=await _dio.getRequest(ApiConstants.getPostByPostId(postId));
    if(response.statusCode==200){
      _postModel=PostModel.fromJson(response.data);
      notifyListeners();
    }
  }

  // post detay erkanındaki like ve dislike butonuna basıldığında
  Future<void> returnPostByPostId(int postId) async {
    notifyListeners();
    var response=await _dio.getRequest(ApiConstants.getPostByPostId(postId));
    if(response.statusCode==200){
      _postModel=PostModel.fromJson(response.data);
      notifyListeners();
    }
  }



  Future<void> likePost (Object data) async{
      var response=await _dio.postRequest(ApiConstants.likePost, data);
      if(response.statusCode==200){
        returnPostByPostId((data as Map<String,dynamic>)["postId"]);
      }
  }

  Future<Response> quotePost (Object data) async{
    var response=await _dio.postRequest(ApiConstants.quotePost, data);
    if(response.statusCode==200){
     return response;
    }
    return response;
  }
}