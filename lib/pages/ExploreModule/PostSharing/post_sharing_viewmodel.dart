import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/category_form_file_model.dart';
import 'package:moto_kent/services/geolacator_service.dart';
import 'package:moto_kent/services/geolacator_service_impl.dart';


import 'package:moto_kent/services/api_service_impl.dart';

class PostSharingViewmodel extends ChangeNotifier {
  List<dynamic> _postCategoryModelList = [];
  List<dynamic> get postCategoryModelList => _postCategoryModelList;
  final ApiServiceImpl _dio=ApiServiceImpl();
  GeolocatorService _geolocatorService=GeolocatorServiceImpl();


  String? _city;
  String? get city=>_city;

  Future<void> fetchPostCategoryList2() async {
    var response = await _dio.getRequest(
        ApiConstants.getAllPostCategoriesFormFile,
       );
    _postCategoryModelList=response.data.map((item) => CategoryFormFileModel.fromJson(item)).toList();

    notifyListeners();
  }


  Future<Response> AddPost(Object requestBody) async {
    try{
          var result =
        await _dio.postRequest(ApiConstants.addPost, requestBody);
    return result;
    }catch(e){
      log(e.toString(),name: "PostSharingViewmodel");
      throw Exception(e.toString());
    }

  }


  Future<void> getCityName () async {
    _city=null;
    notifyListeners();
    LatLng currentLocation=await _geolocatorService.getCurrentLocation();
    _city=await _geolocatorService.getCityNameFromGoogle(currentLocation.latitude, currentLocation.longitude);
    notifyListeners();
  }
}
