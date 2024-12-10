import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/category_form_file_model.dart';


import 'package:moto_kent/services/api_service.dart';
import 'package:moto_kent/services/dio_service_3.dart';

class PostSharingViewmodel extends ChangeNotifier {
  List<dynamic> _postCategoryModelList = [];
  List<dynamic> get postCategoryModelList => _postCategoryModelList;
  final apiService = ApiService();



  Future<void> fetchPostCategoryList2() async {
    var response = await DioService().getRequest(
        ApiConstants.getAllPostCategoriesFormFile,
       );
    _postCategoryModelList=response.data.map((item) => CategoryFormFileModel.fromJson(item)).toList();

    notifyListeners();
  }


  Future<Response> AddPost(Object requestBody) async {
    var result =
        await DioService().postRequest(ApiConstants.addPost, requestBody);
    return result;
  }
}
