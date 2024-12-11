import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/custom_marker_model.dart';
import 'package:moto_kent/services/dio_service_3.dart';


class LoactionIconMapViewmodel extends ChangeNotifier{
  final DioService _dio = DioService();

  List<CustomMarkerModel> _modelList=[];
  List<CustomMarkerModel> get modelList=>_modelList;

  bool _isLoading=false;
  bool get isLoading =>_isLoading;


  Future<void> fetchCustomMarkerItem() async{
    _isLoading=false;
    notifyListeners();
    var response= await _dio.getRequest(ApiConstants.getCustomMarkerItem);
    _modelList=(response.data as List).map((e) => CustomMarkerModel.fromJson(e)).toList();
    _isLoading=true;
    notifyListeners();
  }



}