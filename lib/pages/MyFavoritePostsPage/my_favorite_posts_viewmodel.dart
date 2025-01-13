import 'dart:developer';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/models/post_model.dart';
import 'package:moto_kent/services/dio_service_3.dart';

class MyFavoritePostsViewmodel extends ChangeNotifier {
  DioService _dio = DioService();

  List<PostModel> _postList = [];
  List<PostModel> get postList => _postList;

  Future<List<PostModel>> fetchMyFavoritePosts() async {
    String? userId =
        await SharedPreferencesHelper().getValue<String>("user_id");
    var response =
        await _dio.getRequest(ApiConstants.getMyFavoritePosts(userId!));
    try{
      if (response.statusCode == 200) {
        if (response.data is List) {
          _postList = (response.data as List)
              .map((item) => PostModel.fromJson(item))
              .toList();

        } else {
          throw Exception('Unexpected data format: Expected a list');
        }
      }
      return _postList;
    }catch(ex){
      log(ex.toString(),name: "Error");
      throw Exception("");
    }


  }
}
