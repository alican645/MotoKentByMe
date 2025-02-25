import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moto_kent/models/location_model.dart';

class GoogleMapHelper {
  GoogleMapHelper._();
  static Marker returnMarker({
    required BuildContext context,
    dynamic customMarkerIconBytes,
    required LocationModel location,
    required VoidCallback onPressed,
  }) {
    var marker = Marker(
        onTap: () {
          showDialog(
            context: context,
            builder: (contextt) => AlertDialog(
              actions: [
                Text(location.comment!),
                TextButton(
                    onPressed: () {
                      onPressed.call();
                      Navigator.pop(contextt);
                    }, child: const Text("Yol Tarifi Al"))
              ],
            ),
          );
        },
        position: LatLng(location.latitude!, location.longitude!),
        markerId: MarkerId(location.markerId!),
        icon: customMarkerIconBytes!=null?BitmapDescriptor.bytes(customMarkerIconBytes,
            height: 48, width: 48):BitmapDescriptor.defaultMarker);
    return marker;
  }
}
// await startLocationTracking(location);
//Navigator.pop(contextt);
