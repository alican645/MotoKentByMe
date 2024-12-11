import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/main.dart';
import 'package:moto_kent/pages/LoactionIconMapPage/loaction_icon_map_viewmodel.dart';
import 'package:provider/provider.dart';

///1-) Özelleştirilmiş ikonların backend kodları yazılacak. Ve bir kaçtane
///özel ikonlar eklenecek. FormFile şeklinde kayıt olucak.+
///2-) Özelleştirilmiş ikonların flutter tarafında çekilmesi işlemleri yapılacak.
///3-) Çekilen verilerin haritada gösterilmesi sağlanacak.
///4-) BackEnd de LatLng ve ikonId kayıları yapılacak.
///5-) Flutter tarafında LatLng kayıtları yapılacak.

class LocationIconMapView extends StatefulWidget {
  const LocationIconMapView({super.key});

  @override
  State<LocationIconMapView> createState() => _LocationIconMapViewState();
}

class _LocationIconMapViewState extends State<LocationIconMapView> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  Set<Marker> _markers = {};
  // Dinamik başlangıç konumu
  CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962), // Varsayılan konum
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    _setInitialLocation();
    context.read<LoactionIconMapViewmodel>().fetchCustomMarkerItem();
  }

  /// Telefonun anlık konumunu alıp harita başlangıç konumunu ayarlar
  Future<void> _setInitialLocation() async {
    // Konum izinlerini kontrol et ve iste
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    try {
      // Telefonun anlık konumunu al
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Anlık konumu başlangıç pozisyonu olarak ayarla
      setState(() {
        _initialPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14.5,
        );
      });

      // Harita kontrolcüsünü kullanarak anlık konuma odaklan
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_initialPosition));
    } catch (e) {
    }
  }

  Future<void> _goToCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final GoogleMapController controller = await _controller.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14.5,
        ),
      ));
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            child: GoogleMap(
              mapType: MapType.normal,
              markers: _markers ,
              initialCameraPosition: _initialPosition, // Dinamik başlangıç pozisyonu
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MapIcon(
                    onPressed: _goToCurrentLocation, // Anlık konuma git
                    iconData: Icons.my_location_outlined,
                  ),
                  GestureDetector(
                    onTap: _showIconsModal,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppTheme.themeData.primaryColor,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: Row(
                            children: [
                              Text(
                                "İşaretle",
                                style: TextStyle(color: Colors.white),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  MapIcon(
                    iconData: Icons.refresh_outlined,
                    onPressed: () {},
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showIconsModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Consumer<LoactionIconMapViewmodel>(
        builder: (context, value, child) =>
         GridView.builder(
          padding: const EdgeInsets.all(25),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            childAspectRatio: 1.0,
          ),
          itemCount: 7,
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(color: AppTheme.themeData.primaryColor),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add),
                Text("100"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MapIcon extends StatelessWidget {
  const MapIcon({super.key, required this.iconData, required this.onPressed});
  final IconData iconData;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: AppTheme.themeData.primaryColor,
        borderRadius: BorderRadius.circular(45),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          iconData,
          color: Colors.white,
        ),
      ),
    );
  }
}
