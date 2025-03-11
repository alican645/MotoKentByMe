import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moto_kent/services/geolacator_service_impl.dart';

abstract class GeolocatorService {



  Future<List<dynamic>> searchLocation(String girilenMetin);
  //anlık konumu alan fonksiyon
  Future<LatLng> getCurrentLocation() ;

  //izin kotrolunu sağlayan fonksiyon
  Future<bool> requestPermissionLocation();

  //iki adres arasındaki navigasyon rotasını belirleyen fonksiyon
  Future<Set<Polyline>> getRoute(LatLng startLocation, LatLng destinationLocation);

  Future<LocationDetailModel?> getLocationDetail(String placeId);
  Future<String?> getCityNameFromGoogle(double latitude, double longitude);
  Future<LatLngBounds?> getVisibleRegion(GoogleMapController? mapController);
  Stream<Position> getLocationStream() ;
}