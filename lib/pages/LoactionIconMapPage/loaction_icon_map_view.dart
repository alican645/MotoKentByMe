import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/location_model.dart';
import 'package:moto_kent/pages/LoactionIconMapPage/loaction_icon_map_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// istek gönderirken ve alırken key uyuşmazlığı oluyor

class LocationIconMapView extends StatefulWidget {
  const LocationIconMapView({super.key});

  @override
  State<LocationIconMapView> createState() => _LocationIconMapViewState();
}

class _LocationIconMapViewState extends State<LocationIconMapView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Uint8List? customMarkerIconBytes;
  String? iconPath;

  LoactionIconMapViewmodel? viewmodel;

  Set<Marker> _markers = {};
  // Dinamik başlangıç konumu
  CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962), // Varsayılan konum
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    viewmodel = context.read<LoactionIconMapViewmodel>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initialize();
    },);



  }

  @override
  dispose() {
    super.dispose();
    viewmodel!.dispose();
  }

  Future<void> initialize() async {
    await viewmodel!.fetchCustomMarkerItem();
    await viewmodel!.fetchAllLocations();
    _setInitialLocation();
  }

  /// Marker'ı özelleştirme ve ekleme
  Future<void> _loadCustomMarker(
    LatLng location,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString("user_id");

    LocationModel model = LocationModel()
      .. id=0
      ..longitude = location.longitude
      ..latitude = location.latitude
      ..markerId =
          "${location.latitude}/${location.longitude}/${DateTime.now()}"
      ..createdDate = DateTime.now()
      ..userId = userId
      ..iconPath = iconPath;

    await viewmodel!.addMarker(model);
  }


  Future<void> _selectLocationIcon(String selectIconPath,BuildContext selectContext) async{
    iconPath= selectIconPath;
    Navigator.pop(selectContext);
    viewmodel!.setSelectLocation(true);
  }
  /// Telefon un anlık konumunu alıp harita başlangıç konumunu ayarlar
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
      controller
          .animateCamera(CameraUpdate.newCameraPosition(_initialPosition));
    } catch (e) {}
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
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          Flexible(
            child: viewmodel!.isLoadingAllMarker? Stack(
              children: [
                Consumer<LoactionIconMapViewmodel>(
                  builder: (context, value, child) => GoogleMap(
                    onTap: (argument) {
                      if (value.selectLocation) {
                        LatLng location =
                            LatLng(argument.latitude, argument.longitude);
                        _loadCustomMarker(location);
                      }
                      value.setSelectLocation(false);
                    },
                    mapType: MapType.normal,
                    markers: value.markerList,
                    initialCameraPosition:
                        _initialPosition, // Dinamik başlangıç pozisyonu
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),
                Provider.of<LoactionIconMapViewmodel>(context).selectLocation
                    ? Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                              padding: EdgeInsets.all(10),
                              color: Colors.white,
                              child: CircularProgressIndicator()),
                        ),
                      )
                    : SizedBox(),
              ],
            ): Center(child: CircularProgressIndicator(),)
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
      builder: (showModalBottomSheetContext) =>
          Consumer<LoactionIconMapViewmodel>(
        builder: (context, value, child) => GridView.builder(
          padding: const EdgeInsets.all(25),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            childAspectRatio: 1.0,
          ),
          itemCount: value.modelList.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () async {
              _selectLocationIcon(value.modelList[index].iconPath!,showModalBottomSheetContext);

            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                    child: Image.network(
                  '${ApiConstants.baseUrl}${value.modelList[index].iconPath}',
                  fit: BoxFit.fitHeight,
                )),
                Text(value.modelList[index].iconName!),
                value.modelList[index].price == 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Text(
                              "Free",
                              style: TextStyle(
                                  color: AppTheme.themeData.primaryColor),
                            ),
                          ])
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(value.modelList[index].price.toString(),
                              style: TextStyle(
                                  color: AppTheme.themeData.primaryColor)),
                          SizedBox(
                            width: 1,
                          ),
                          Icon(Icons.monetization_on_outlined,
                              size: 20, color: AppTheme.themeData.primaryColor)
                        ],
                      )
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
