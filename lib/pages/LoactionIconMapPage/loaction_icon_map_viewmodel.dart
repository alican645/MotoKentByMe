import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/constants/data_objects.dart';
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


  bool _selectLocation = false;
  bool get selectLocation => _selectLocation;
  void setSelectLocation(bool value) {
    _selectLocation = value;
    notifyListeners();
  }

  // Dinamik başlangıç konumu
  CameraPosition? _initialPosition  ;
  CameraPosition? get initialPosition=>_initialPosition  ;

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  Completer<GoogleMapController> get controller =>_controller;

  bool _initialFlag=false;
  bool get initialFlag=>_initialFlag;


  Future<void> fetchCustomMarkerItem() async {

    var response = await _dio.getRequest(ApiConstants.getCustomMarkerItem);
    _modelList = (response.data as List)
        .map((e) => CustomMarkerModel.fromJson(e))
        .toList();


  }

  Future<Uint8List> fetchCustomMarkerIconBytes(String endpoint) async {
    Uint8List data;
    _selectLocation = false;
    var response = await _dio.getRequestUnit8List(endpoint);

    data = response.data;
    return data;
  }

  Future<void> fetchAllLocations(BuildContext context) async {

    String? userId=await SharedPreferencesHelper().getValue<String>("user_id");
    var response = await _dio.getRequest("${ApiConstants.getAllLocations}?userId=$userId");

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
          onTap: (){
            showDialog(context: context, builder: (context) => AlertDialog(
              actions: [
                Text(location.longitude.toString()),
                Text(location.latitude.toString())
              ],
            ),);
          },
          position: LatLng(location.latitude!, location.longitude!),
          markerId: MarkerId(location.markerId!),
          icon: BitmapDescriptor.bytes(customMarkerIconBytes,
              height: 48, width: 48)
      )
      );
    }).toList();



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

  Future<void> addMarker(LocationModel model,String iconPath) async{
    Uint8List customMarkerIconBytes;
    customMarkerIconBytes =await fetchCustomMarkerIconBytes('${ApiConstants.baseUrl}${iconPath}');

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

  Future<void> initialize(BuildContext context) async {

    try{
      _initialFlag=false;
      notifyListeners();
      Future.wait ([
        _setInitialLocation(),
        fetchCustomMarkerItem(),
        fetchAllLocations(context),
        fetchUserAppMarkerIconTotalToken(),
      ] );
      _initialFlag = true;
      notifyListeners();
    }catch(e){
      log("GoogleMapBaşlatmaHatası",error: e);
    }
  }




  Future<void> _setInitialLocation() async {
    // Konum izinlerini kontrol et ve iste
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,);
    try {
        LocationModel model =LocationModel(
            latitude: position.latitude,
            longitude: position.longitude,
            markerId: "me",
            iconPath: "/customLocationIconsFolder/Me.png"
        );
       addMarker(model,model.iconPath!);

        _initialPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 19,
        );

      // Harita kontrolcüsünü kullanarak anlık konuma odaklan
      final GoogleMapController controller = await _controller.future;
      controller
          .animateCamera(CameraUpdate.newCameraPosition(_initialPosition!));
    } catch (e) {
      log("googleMapsException",error: e);
    }
  }

  Future<void> resetMap (BuildContext context) async{
    String? userId=await SharedPreferencesHelper().getValue<String>("user_id");
    var response = await _dio.postRequest(ApiConstants.resetMap, DataObjects.onlyUserIdObject(userId!));
    if(response.statusCode==200){
      _markerList={markerList.toList()[0]};
      fetchAllLocations(context);
      notifyListeners();
    }
  }




}
