import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/category_form_file_model.dart';
import 'package:moto_kent/services/dio_service_3.dart';

class CreateChatGroupViewmodel extends ChangeNotifier {
  List<dynamic> _postCategoryModelList = [];
  List<dynamic> get postCategoryModelList => _postCategoryModelList;
  final apiService = DioService();

  Future<void> fetchPostCategoryList2() async {
    var response = await apiService.getRequest(
      ApiConstants.getAllPostCategoriesFormFile,
    );
    _postCategoryModelList = response.data
        .map((item) => CategoryFormFileModel.fromJson(item))
        .toList();
    notifyListeners();
  }

  Future<Response> createChatGroup(Object object) async {
    var response=await apiService.postRequest(ApiConstants.createChatGroup, object);
    return response;
  }
}
