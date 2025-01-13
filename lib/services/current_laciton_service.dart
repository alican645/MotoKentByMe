

import 'package:geolocator/geolocator.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/models/last_location_model.dart';
import 'package:moto_kent/services/dio_service_3.dart';


class CurrentLacitonService {

  Future<void> initialize() async {
    await getCurrentLocation();
  }

  /// Konum izinlerini kontrol eder ve gerekirse izin ister.
  Future<bool> _handleLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        //print('Konum izni reddedildi.');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      //print('Konum izinleri kalıcı olarak reddedildi. Ayarlardan izin verin.');
      return false;
    }

    return true;
  }

  /// Anlık konumu alır.
  Future<void> getCurrentLocation() async {
    try {
      bool isPermissionGranted = await _handleLocationPermission();
      if (!isPermissionGranted) {

      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high
      )
      );

      String? userId=await SharedPreferencesHelper().getValue<String>("user_id");
      //print('Anlık Konum: ${position.latitude}, ${position.longitude}');

      var lastLocation = LastLocationModel(
        userId: userId,
        createdDate: DateTime.now(),
        lat: position.latitude,
        lng: position.longitude
      );

      await SharedPreferencesHelper().setValue<double>("last_location_latidue", position.latitude);
      await SharedPreferencesHelper().setValue<double>("last_location_longitude", position.longitude);
      DioService().postRequest(ApiConstants.addUserLastLocation, lastLocation.toJson());
    } catch (e) {
      //print('Konum alınırken hata oluştu: $e');

    }

  }
}