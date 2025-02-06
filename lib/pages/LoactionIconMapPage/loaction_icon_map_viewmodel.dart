import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
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

  List<dynamic> _placePredictions = [];
  List<dynamic> get placePredictions => _placePredictions;

  int _totalMarkerIconToken = 0;
  int get totalMarkerIconToken => _totalMarkerIconToken;

  List<CustomMarkerModel> _modelList = [];
  List<CustomMarkerModel> get modelList => _modelList;

  Set<Marker> _markerList = {};
  Set<Marker> get markerList => _markerList;
  Set<Polyline> _polylines = {};
  Set<Polyline> get polylines => _polylines;
  
  List<LatLng> _polylineCoordinates = [];
  List<LatLng> get polylineCoordinates => _polylineCoordinates;

  LatLng? currentLocation;
  LatLng? destinationLocation;

  bool _selectLocation = false;
  bool get selectLocation => _selectLocation;
  void setSelectLocation(bool value) {
    _selectLocation = value;
    notifyListeners();
  }

  String _serchBarText = "";
  String get serchBarText => _serchBarText;

  // Dinamik başlangıç konumu
  CameraPosition? _initialPosition;
  CameraPosition? get initialPosition => _initialPosition;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Completer<GoogleMapController> get controller => _controller;

  bool _initialFlag = false;
  bool get initialFlag => _initialFlag;

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
    String? userId =
        await SharedPreferencesHelper().getValue<String>("user_id");
    var response =
        await _dio.getRequest("${ApiConstants.getAllLocations}?userId=$userId");

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

          infoWindow:  InfoWindow(
          title: "Kullanıcı Yorumu:",
          snippet: location.comment,
          onTap: () {
            showDialog(
            context: context,
            builder: (contextt) => AlertDialog(
              actions: [
                TextButton(
                    onPressed: () async {
                      _polylineCoordinates.clear();
                      LatLng startLocation = await getCurrentLocation();
                      LatLng destinationLocation =
                          LatLng(location.latitude!, location.longitude!);
                      await _getRoute(startLocation, destinationLocation);
                      Navigator.pop(contextt);
                    },
                    child: const Text("Yol Tarifi Al"))
              ],
            ),
          );
          },
        ),
          position: LatLng(location.latitude!, location.longitude!),
          markerId: MarkerId(location.markerId!),
          icon: BitmapDescriptor.bytes(customMarkerIconBytes,
              height: 48, width: 48)));
    }).toList();
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
    BuildContext context,
    LocationModel model,
    String iconPath,
  ) async {
    Uint8List customMarkerIconBytes;
    customMarkerIconBytes =
        await fetchCustomMarkerIconBytes('${ApiConstants.baseUrl}${iconPath}');

    markerList.add(Marker(

        infoWindow: InfoWindow(
          title: "Kullanıcı Yorumu:",
          snippet: model.comment,
          onTap: () {
            showDialog(
            context: context,
            builder: (contextt) => AlertDialog(
              actions: [
                Text("Yol tarifi almak ister misiniz?"),
                TextButton(
                    onPressed: () async {
                      _polylineCoordinates.clear();
                      LatLng startLocation = await getCurrentLocation();
                      LatLng destinationLocation =
                          LatLng(model.latitude!, model.longitude!);
                      await _getRoute(startLocation, destinationLocation);
                      Navigator.pop(contextt);
                    },
                    child: const Text("Yol Tarifi Al"))
              ],
            ),
          );
          },
        ),
        position: LatLng(model.latitude!, model.longitude!),
        markerId: MarkerId(model.markerId!),
        icon: BitmapDescriptor.bytes(customMarkerIconBytes,
            height: 48, width: 48)));
    notifyListeners();
  }

  Future<void> fetchUserAppMarkerIconTotalToken() async {
    var userID = await SharedPreferencesHelper().getValue<String>("user_id");
    var response = await _dio
        .getRequest(ApiConstants.getAppMarkerIconTokenByUserId(userID!));
    if (response.statusCode == 200) {
      _totalMarkerIconToken =
          (response.data as Map<String, dynamic>)["totalToken"];
    }
  }

  Future<void> initialize(
    BuildContext context,
  ) async {
    try {
      _initialFlag = false;
      notifyListeners();
      Future.wait([

        fetchCustomMarkerItem(),
        fetchAllLocations(context),
        fetchUserAppMarkerIconTotalToken(),
      ]);
      _initialFlag = true;
      notifyListeners();
    } catch (e) {
      dev.log("GoogleMapBaşlatmaHatası", error: e);
    }
  }



  Future<void> startLocationUpdates(BuildContext context) async {
    // Konum izinlerini kontrol et ve iste
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    // Konum güncellemelerini dinle
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Her 10 metrede bir güncelleme alır
      ),
    ).listen((Position position) async {
      // Güncel konum bilgisi
      LatLng currentLatLng = LatLng(position.latitude, position.longitude);

      // Marker güncelleme işlemi
      LocationModel model = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        markerId: "me",
        iconPath: "/customLocationIconsFolder/Me.png",

      );

      // Mevcut marker'ı eklemek veya güncellemek için addMarker fonksiyonunu çağırabilirsiniz.
      
      addMarker(context, model, model.iconPath!);
      
      // Kamera pozisyonunu güncelle
        _initialPosition = CameraPosition(
        target: currentLatLng,
        zoom: 19,
      );
       _updateRoute();
       notifyListeners();
      // // Harita kontrolcüsünü kullanarak kamera hareketini sağla
      // final GoogleMapController controller = await _controller.future;
      // controller.animateCamera(CameraUpdate.newCameraPosition(_initialPosition!));
      // notifyListeners();
    });
  }

  // haritadaki işaretçileri sıfırlayan fonksiyon
  Future<void> resetMap(BuildContext context) async {
    String? userId =
        await SharedPreferencesHelper().getValue<String>("user_id");
    var response = await _dio.postRequest(
        ApiConstants.resetMap, DataObjects.onlyUserIdObject(userId!));
    if (response.statusCode == 200) {
      _markerList = {markerList.toList()[0]};
      fetchAllLocations(context);
      notifyListeners();
    }
  }

  final String _apiKey = "AIzaSyBAJoP8ROy-LAmknKg7h9MfP8hCpoKeGRM";

  // Seçilen konumun formatlı adresi (örneğin TextField’a göstermek için)
  String _seciliAdres = "";
  String get seciliAdres => _seciliAdres;

  // Debounce için timer
  Timer? _debounceTimer;

  /// TextField içinde her karakter girildiğinde çağrılacak
  void aramaMetniDegisti(String query) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        konumAra(query);
      } else {
        _placePredictions.clear();
        notifyListeners();
      }
    });
  }

  /// Google Places Autocomplete endpoint’ine istek atar.
  Future<void> konumAra(String girilenMetin) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=$girilenMetin&key=$_apiKey&components=country:tr';

    try {
      final response = await _dio.getRequest(url);
      if (response.statusCode == 200) {
        _placePredictions = response.data['predictions'];
        notifyListeners();
      }
    } catch (e) {
      dev.log('Konum aramada hata: $e');
    }
  }

  /// Autocomplete sonucunda seçilen bir Place ID için detay bilgisini alır.
  /// Lat,Lng alarak haritayı o noktaya zoomlar ve formatlı adresi saklar.
  Future<void> konumDetayiGetir(String placeId) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/details/json'
        '?place_id=$placeId&key=$_apiKey';

    try {
      final response = await _dio.getRequest(url);
      if (response.statusCode == 200) {
        final result = response.data['result'];
        double lat = result['geometry']['location']['lat'];
        double lng = result['geometry']['location']['lng'];

        // Harita kamerasını oynat
        final GoogleMapController gController = await _controller.future;
        gController
            .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15));

        // Seçilen adresi ayarla
        _seciliAdres = result['formatted_address'] ?? "";
        // Arama listesini temizle
        _placePredictions = [];
        notifyListeners();
      }
    } catch (e) {
      dev.log('Konum detayını alırken hata oluştu: $e');
    }
  }

  Future<void> _getRoute(
      LatLng startLocation, LatLng destinationLocation) async {
    // API endpoint URL'si
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startLocation.latitude},${startLocation.longitude}'
        '&destination=${destinationLocation.latitude},${destinationLocation.longitude}&key=$_apiKey';

    final response = await _dio.getRequest(url);
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
          _polylineCoordinates.clear();
          for (var point in result) {
            _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          }
          // Polyline'ı set'e ekliyoruz
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: polylineCoordinates,
              color: const Color.fromARGB(255, 249, 1, 1),
              width: 7,
            ),
          );
          notifyListeners();
        }
      }
    } else {
      debugPrint("Rota bilgileri alınamadı. Hata kodu: ${response.statusCode}");
    }
  }

  Future<LatLng> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      dev.log("Konum hatası: $e", name: "_CurrentLocation=>KonumHatası");
      throw Exception(e.toString());
    }
  }

void _updateRoute() {
    if (currentLocation == null || _polylineCoordinates.isEmpty) return;

    // Find the closest point in the route to the current location
    int closestIndex = 0;
    double closestDistance = double.infinity;
    for (int i = 0; i < _polylineCoordinates.length; i++) {
      double distance = _calculateDistance(currentLocation!, _polylineCoordinates[i]);
      if (distance < closestDistance) {
        closestDistance = distance;
        closestIndex = i;
      }
    }

    // Take the remaining points from the closest index
    List<LatLng> remainingRoute = _polylineCoordinates.sublist(closestIndex);

   
      polylines.clear();
      polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          points: remainingRoute,
          color: Colors.blue,
          width: 5,
        ),
      );
   
  }

  double _calculateDistance(LatLng a, LatLng b) {
    const double earthRadius = 6371000; // meters
    double dLat = _toRadians(b.latitude - a.latitude);
    double dLng = _toRadians(b.longitude - a.longitude);
    double sinDLat = sin(dLat / 2);
    double sinDLng = sin(dLng / 2);
    double cosA = cos(_toRadians(a.latitude)) * cos(_toRadians(b.latitude));
    double calc = sinDLat * sinDLat + cosA * sinDLng * sinDLng;
    double c = 2 * atan2(sqrt(calc), sqrt(1 - calc));
    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * pi / 180;
  }








}
