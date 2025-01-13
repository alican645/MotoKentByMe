import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/models/custom_marker_model.dart';
import 'package:moto_kent/models/location_model.dart';
import 'package:moto_kent/services/dio_service_3.dart';

class LoactionIconMapViewmodel extends ChangeNotifier {
  final DioService _dio = DioService();

  int _totalMarkerIconToken=0;
  int get totalMarkerIconToken=>_totalMarkerIconToken;

  List<CustomMarkerModel> _modelList = [];
  List<CustomMarkerModel> get modelList => _modelList;

  Set<Marker> _markerList = {};
  Set<Marker> get markerList => _markerList;

  bool _isLoadingAllMarker = false;
  bool get isLoadingAllMarker => _isLoadingAllMarker;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _selectLocation = false;
  bool get selectLocation => _selectLocation;
  void setSelectLocation(bool value) {
    _selectLocation = value;
    notifyListeners();
  }

  Future<void> fetchCustomMarkerItem() async {
    _isLoading = false;
    notifyListeners();
    var response = await _dio.getRequest(ApiConstants.getCustomMarkerItem);
    _modelList = (response.data as List)
        .map((e) => CustomMarkerModel.fromJson(e))
        .toList();
    _isLoading = true;
    notifyListeners();
  }

  Future<Uint8List> fetchCustomMarkerIconBytes(String endpoint) async {
    Uint8List data;
    _selectLocation = false;
    var response = await _dio.getRequestUnit8List(endpoint);
    notifyListeners();
    data = response.data;
    return data;
  }

  Future<void> fetchAllLocations() async {
    _isLoadingAllMarker = false;
    var response = await _dio.getRequest(ApiConstants.getAllLocations);

    (response.data as List).map((e) async {
      var location = LocationModel.fromJson(e);
      var customMarkerIconBytes;
      try {
        var response = await _dio
            .getRequestUnit8List('${ApiConstants.baseUrl}${location.iconPath}');
        customMarkerIconBytes = response.data;
      } catch (e) {
        throw Exception(e);
      }
      _markerList.add(Marker(
          position: LatLng(location.latitude!, location.longitude!),
          markerId: MarkerId(location.markerId!),
          icon: BitmapDescriptor.bytes(customMarkerIconBytes,
              height: 48, width: 48)
      )
      );
    }).toList();
    _isLoadingAllMarker = true;

    notifyListeners();
  }

  Future<Response> createMarker(LocationModel model) async {

    try {
      var response = await _dio.postRequest(ApiConstants.addLocation, model.toJson());
      if (response.statusCode == 200) {
        fetchUserAppMarkerIconTotalToken();
        notifyListeners();
      }
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addMarker(LocationModel model) async{
    Uint8List customMarkerIconBytes;
    customMarkerIconBytes =await fetchCustomMarkerIconBytes('${ApiConstants.baseUrl}${model.iconPath}');

    markerList.add(Marker(
      position: LatLng(model.latitude!, model.longitude!),
      markerId: MarkerId(model.markerId!),
      icon: BitmapDescriptor.bytes(customMarkerIconBytes,
          height: 48, width: 48)
    ));
    notifyListeners();
  }

  Future<void> fetchUserAppMarkerIconTotalToken () async{
    var userID=await SharedPreferencesHelper().getValue<String>("user_id");
    var response =await _dio.getRequest(ApiConstants.getAppMarkerIconTokenByUserId(userID!));
    if(response.statusCode==200){
      _totalMarkerIconToken=(response.data as Map<String,dynamic>)["totalToken"];
    }
  }
}
