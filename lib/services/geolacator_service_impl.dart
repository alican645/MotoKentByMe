import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moto_kent/services/geolacator_service.dart';
import 'package:moto_kent/services/api_service_impl.dart';
import 'package:moto_kent/services/iapi_service.dart';

class GeolocatorServiceImpl implements GeolocatorService {


  IApiService dio = ApiServiceImpl();
  final String _apiKey = "AIzaSyDHRNFT_MzvYjYopYaM5PDcrDHQGcDO4t4";



  //anlık konumu alan fonksiyon
  @override
  Future<LatLng> getCurrentLocation() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      throw LocationException('Location permission denied');
    } else {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        return LatLng(position.latitude, position.longitude);
      } catch (e) {
        log(e.toString(), name: 'GeolocatorService');
        throw LocationException('Failed to get current location: $e');
      }
    }
  }

  //izin kotrolunu sağlayan fonksiyon
  @override
  Future<bool> requestPermissionLocation() async {
    var permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw LocationException('Location permission denied');
    } else {
      return true;
    }
  }

  //iki adres arasındaki navigasyon rotasını belirleyen fonksiyon
  @override
  Future<Set<Polyline>> getRoute(
      LatLng startLocation, LatLng destinationLocation) async {
    
    final List<LatLng> polylineCoordinates = [];
    final Set<Polyline> polylines = {};

    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startLocation.latitude},${startLocation.longitude}'
        '&destination=${destinationLocation.latitude},${destinationLocation.longitude}&key=$_apiKey';

    final response = await dio.getRequest(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = (response.data as Map<String, dynamic>);

      if ((data['routes'] as List).isNotEmpty) {
        // İlk rotayı seçiyoruz
        var route = data['routes'][0];
        // Overview polyline'ı alıyoruz
        String encodedPolyline = route['overview_polyline']['points'];
        // PolylinePoints ile decode ediyoruz
        PolylinePoints polylinePoints = PolylinePoints();
        List<PointLatLng> result =
            polylinePoints.decodePolyline(encodedPolyline);

        // Decode edilmiş noktaları LatLng'e çeviriyoruz
        if (result.isNotEmpty) {
          polylineCoordinates.clear();
          for (var point in result) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          }
          // Polyline'ı set'e ekliyoruz
          polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: polylineCoordinates,
              color: const Color.fromARGB(255, 249, 1, 1),
              width: 7,
            ),
          );

          return polylines;
        }
        return polylines;
      }
      return polylines;
    } else {
      return polylines;
    }
  }


  @override
  Future<List<dynamic>> searchLocation(String girilenMetin) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=$girilenMetin&key=$_apiKey&components=country:tr';
    List<dynamic> placePredictions = [];
    try {
      final response = await dio.getRequest(url);
      if (response.statusCode == 200) {
        placePredictions = response.data['predictions'];
        return placePredictions;
      }else{
        return placePredictions;
      }
    } catch (e) {
      log(e.toString(), name: 'GeolocatorService');
      throw LocationException('Failed to get place predictions: $e');
    }
  }


  @override
  Future<LocationDetailModel?> getLocationDetail(String placeId) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/details/json'
        '?place_id=$placeId&key=$_apiKey';
    try {
      final response = await dio.getRequest(url);
      if (response.statusCode == 200) {
        final result = response.data['result'];
          var locationDetailModel=LocationDetailModel(
            lng: result['geometry']['location']['lng'],
            lat:result['geometry']['location']['lat'],
            formattedAddress: result['formatted_address']
          );
        return locationDetailModel;
        }
        return null;
        
      }
     catch (e) {
      log('Konum detayını alırken hata oluştu: $e');
    }
    return null;
  }

  @override
  Future<String?> getCityNameFromGoogle(double latitude, double longitude) async {
    // Google API anahtarınızı buraya ekleyin

    final String url =
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$_apiKey';

    try {
      final response = await dio.getRequest(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data as Map<String, dynamic>;

        if (data['status'] == 'OK') {
          final List results = data['results'];

          // Adres bileşenlerini tarayarak "locality" (şehir) bilgisini arıyoruz.
          for (var result in results) {
            for (var component in result['address_components']) {
              List types = component['types'];
              if (types.contains('locality')) {
                return component['long_name'];
              }
            }
          }
          return 'Şehir bulunamadı';
        } else {
          return 'Google API hatası: ${data['status']}';
        }
      } else {
        return 'HTTP Hatası: ${response.statusCode}';
      }
    } catch (e) {
      log(e.toString(),name:"şehir adı bulma");
      return null;
    }
  }

  @override
  Future<LatLngBounds?> getVisibleRegion(GoogleMapController? mapController) async {
    if (mapController == null) return null;
    final visibleRegion = await mapController.getVisibleRegion();
    LatLngBounds? _currentVisibleArea = LatLngBounds(
      northeast: visibleRegion.northeast,
      southwest: visibleRegion.southwest,
    );
     return _currentVisibleArea;
  }

  @override
  Stream<Position> getLocationStream() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Her 10 metrede bir güncelle
    );
    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }



}

class LocationException implements Exception {
  final String message;
  LocationException(this.message);

  @override
  String toString() => 'LocationException: $message';
}


class LocationDetailModel {
  double? lat;
  double? lng;
  String? formattedAddress;

  LocationDetailModel({this.lat, this.lng, this.formattedAddress});

  LocationDetailModel.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
    formattedAddress = json['formatted_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['formatted_address'] = this.formattedAddress;
    return data;
  }
}