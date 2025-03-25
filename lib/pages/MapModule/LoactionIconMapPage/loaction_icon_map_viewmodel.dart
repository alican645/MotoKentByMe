import 'dart:async';
import 'dart:developer' as dev;
import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/constants/data_objects.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/custom_marker_model.dart';
import 'package:moto_kent/models/location_model.dart';
import 'package:moto_kent/services/geolacator_service.dart';
import 'package:moto_kent/services/geolacator_service_impl.dart';
import 'package:moto_kent/services/api_service_impl.dart';

class LoactionIconMapViewmodel extends ChangeNotifier {
  final ApiServiceImpl _dio = ApiServiceImpl();
  final GeolocatorService _geolocatorService = GeolocatorServiceImpl();

  // Debounce için timer
  Timer? _debounceTimer;

  List<PlacePrediction> _placePredictions = [];
  List<PlacePrediction> get placePredictions => _placePredictions;

  int _totalMarkerIconToken = 0;
  int get totalMarkerIconToken => _totalMarkerIconToken;

  List<CustomMarkerModel> _modelList = [];
  List<CustomMarkerModel> get modelList => _modelList;

  Set<Marker> _markerList = {};
  Set<Marker> get markerList => _markerList;

  Set<Polyline> _polylines = {};
  Set<Polyline> get polylines => _polylines;

  final List<LatLng> _polylineCoordinates = [];
  List<LatLng> get polylineCoordinates => _polylineCoordinates;

  LatLng? currentLocation;
  LatLng? destinationLocation;

  bool _locationIsSelected = false;
  bool get locationIsSelected => _locationIsSelected;
  void setLocationIsSelected(bool value) {
    _locationIsSelected = value;
    notifyListeners();
  }

  final String _serchBarText = "";
  String get serchBarText => _serchBarText;

  // Dinamik başlangıç konumu
  CameraPosition? _initialPosition;
  CameraPosition? get initialPosition => _initialPosition;

  bool _initialFlag = false;
  bool get initialFlag => _initialFlag;

  bool _fetchCustomMarkerItemFlag = false;
  bool get fetchCustomMarkerItemFlag => _fetchCustomMarkerItemFlag;

  Future<void> fetchCustomMarkerItem() async {
    _fetchCustomMarkerItemFlag = false;
    notifyListeners();
    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    var response =
        await _dio.getRequest(ApiConstants.getCustomMarkerItem(userId!));
    _modelList = (response.data["locationIconDtos"] as List)
        .map((e) => CustomMarkerModel.fromJson(e))
        .toList();
    _fetchCustomMarkerItemFlag = true;
    notifyListeners();
  }

  Future<Uint8List> fetchCustomMarkerIconBytes(String endpoint) async {
    Uint8List data;
    var response = await _dio.getRequestUnit8List(endpoint);
    data = response.data;
    return data;
  }

  Future<void> fetchAllLocations(
      Marker Function(LocationModel location, Uint8List byteData)
          marker) async {
    _initialFlag = false;
    _markerList.clear();
    notifyListeners();

    try {
      var response = await _dio.getRequest(ApiConstants.getAllLocations);
      var dataList = (response.data as List);
      await Future.wait(dataList.map((e) async {
        var location = LocationModel.fromJson(e);
        dynamic customMarkerIconBytes;
        try {
          var response = await _dio.getRequestUnit8List(
              '${ApiConstants.baseUrl}${location.iconPath}');
          customMarkerIconBytes = await response.data;
        } catch (e) {
          throw Exception(e);
        }
        _markerList.add(marker(location, customMarkerIconBytes));
        await Future.delayed(const Duration(seconds: 1));
      }).toList());
    } catch (ex) {
      log(ex.toString());
    }
    _initialFlag = true;
    notifyListeners();
  }

  Future<void> fetchAllLocationsByCategoryId(
    int categoryId,
    Marker Function(LocationModel location, Uint8List byteData) marker,
  ) async {
    _initialFlag = false;
    _markerList.clear();
    notifyListeners();

    var response = await _dio
        .getRequest(ApiConstants.getAllLocationsByCategoryId(categoryId));
    var dataList = (response.data as List);
    await Future.wait(dataList.map((e) async {
      var location = LocationModel.fromJson(e);
      dynamic customMarkerIconBytes;
      try {
        var response = await _dio
            .getRequestUnit8List('${ApiConstants.baseUrl}${location.iconPath}');
        customMarkerIconBytes = await response.data;
      } catch (e) {
        throw Exception(e);
      }
      _markerList.add(marker(location, customMarkerIconBytes));
      await Future.delayed(const Duration(seconds: 1));
    }).toList());

    _initialFlag = true;
    notifyListeners();
  }

  Future<void> getRoute(LocationModel location) async {
    _isStartLocationTracking = true;
    notifyListeners();
    _polylineCoordinates.clear();
    LatLng startLocation = await _geolocatorService.getCurrentLocation();
    LatLng destinationLocation =
        LatLng(location.latitude!, location.longitude!);
    _polylines =
        await _geolocatorService.getRoute(startLocation, destinationLocation);
    notifyListeners();
  }

  bool _isStartLocationTracking = false;
  bool get isStartLocationTracking => _isStartLocationTracking;

  Future<void> stopLocationTracking() async {
    _polylineCoordinates.clear();
    _polylines.clear();
    _isStartLocationTracking = false;
    notifyListeners();
  }

  Future<Response> createMarker(LocationModel model) async {
    try {
      var response =
          await _dio.postRequest(ApiConstants.addLocation, model.toJson());
      if (response.statusCode == 200) {
        fetchUserAppMarkerIconTotalToken();
        notifyListeners();
      }
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addMarker(
    Marker Function(LocationModel location, Uint8List byteData) marker,
    LocationModel model,
    String iconPath,
  ) async {
    Uint8List customMarkerIconBytes;
    customMarkerIconBytes =
        await fetchCustomMarkerIconBytes('${ApiConstants.baseUrl}${iconPath}');
    _locationIsSelected = false;
    markerList.add(marker(model, customMarkerIconBytes));
    notifyListeners();
  }

  Future<void> fetchUserAppMarkerIconTotalToken() async {
    var userID = await LocalStorageImpl().getValue<String>("user_id");
    var response = await _dio
        .getRequest(ApiConstants.getAppMarkerIconTokenByUserId(userID!));
    if (response.statusCode == 200) {
      _totalMarkerIconToken =
          (response.data as Map<String, dynamic>)["totalToken"];
    }
  }

  Future<void> setInitialLocation(LatLng? location,
      {required bool isCallForHelp}) async {
    if (isCallForHelp) {
      _initialPosition = CameraPosition(
        target: location!,
        zoom: 29,
      );
    } else {
      LatLng latLng = await _geolocatorService.getCurrentLocation();
      currentLocation = latLng;
      _initialPosition = CameraPosition(
        target: latLng,
        zoom: 29,
      );
    }
    notifyListeners();
  }

  // haritadaki işaretçileri sıfırlayan fonksiyon
  Future<void> resetMap(
      Marker Function(LocationModel location, Uint8List byteData)
          marker) async {
    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    var response = await _dio.postRequest(
        ApiConstants.resetMap, DataObjects.onlyUserIdObject(userId!));
    if (response.statusCode == 200) {
      _markerList = {markerList.toList()[0]};
      fetchAllLocations(marker);
      notifyListeners();
    }
  }

  //Google Places Autocomplete endpoint’ine istek atar.
  Future<void> konumAra(String query) async {
    try {
      if (_debounceTimer?.isActive ?? false) {
        _debounceTimer?.cancel();
      }
      _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
        if (query.isNotEmpty) {
          _placePredictions = await _geolocatorService.searchLocation(query);
        } else {
          _placePredictions.clear();
          notifyListeners();
        }
      });

      notifyListeners();
    } catch (e) {
      dev.log('Konum aramada hata: $e');
    }
  }

  Future<LocationDetailModel?> getLocationDetail(
      String placeId, Completer<GoogleMapController> controller) async {
    try {
      var data = await _geolocatorService.getLocationDetail(placeId);
      if (data != null) {
        controller.future.then((controller) {
          controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(data.lat!, data.lng!), zoom: 15)));
        });

        notifyListeners();
        return data;
      }
      return null;
    } catch (e) {
      dev.log('Konum detayı alınırken hata: $e');
      return null;
    }
  }
}
