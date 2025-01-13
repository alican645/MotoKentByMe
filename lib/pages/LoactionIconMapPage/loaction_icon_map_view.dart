import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/models/location_model.dart';
import 'package:moto_kent/pages/LoactionIconMapPage/loaction_icon_map_viewmodel.dart';
import 'package:moto_kent/pages/LoactionIconMapPage/widgets/gridview_bottom_modal_sheet.dart';
import 'package:moto_kent/pages/LoactionIconMapPage/widgets/map_icon.dart';
import 'package:moto_kent/services/generic_signalr_service.dart';
import 'package:provider/provider.dart';



class LocationIconMapView extends StatefulWidget {
  const LocationIconMapView({super.key});

  @override
  State<LocationIconMapView> createState() => _LocationIconMapViewState();
}

class _LocationIconMapViewState extends State<LocationIconMapView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  GenericSignalRService signalRService = GenericSignalRService(
      endpoint: ApiConstants.signalRLocationHubEndpoint,
      methodName: "AddLocation");

  Uint8List? customMarkerIconBytes;
  String? iconPath;
  int? iconPrice;

  LoactionIconMapViewmodel? viewmodel;

  // Dinamik başlangıç konumu
  CameraPosition? _initialPosition  ;

  @override
  void initState() {
    super.initState();
    viewmodel = context.read<LoactionIconMapViewmodel>();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        initialize();
        signalRService.initializeSignalR();

        signalRService.onReceiveMessage = (arguments) {
          final json = arguments[0] as Map<String, dynamic>;
          LocationModel model = LocationModel.fromJson(json);
          viewmodel!.addMarker(model);

        };
      },
    );
  }

  @override
  dispose() {
    super.dispose();
    viewmodel!.dispose();
  }

  Future<void> initialize() async {
    await viewmodel!.fetchCustomMarkerItem();
    await viewmodel!.fetchAllLocations();
    await viewmodel!.fetchUserAppMarkerIconTotalToken();
    _setInitialLocation();
  }

  /// Marker'ı özelleştirme ve ekleme
  Future<void> _loadCustomMarker(
    LatLng location,
  ) async {
    var prefs = SharedPreferencesHelper();
    String? userId =await prefs.getValue<String>("user_id");

    LocationModel model = LocationModel()
      ..id = 0
      ..longitude = location.longitude
      ..latitude = location.latitude
      ..markerId =
          "${location.latitude}/${location.longitude}/${DateTime.now()}"
      ..createdDate = DateTime.now()
      ..userId = userId
      ..iconPath = iconPath
      ..iconPrice=iconPrice;
try {
  var response = await viewmodel!.createMarker(model);

  if(response.statusCode!=200){
    showDialog(context: context, builder: (sdcontext) {
      
      return AlertDialog(
        title: Text(response.data),
      );
    },);
  }
}catch(e){
  showDialog(context: context, builder: (sdcontext) {

    return AlertDialog(
      title: Text(e.toString()),
    );
  },);
}
  }

  Future<void> _selectLocationIcon(int selectIconPrice,
      String selectIconPath, BuildContext selectContext) async {
    iconPath = selectIconPath;
    iconPrice=selectIconPrice;
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
          zoom: 19,
        );

        LocationModel model =LocationModel(
          latitude: position.latitude,
          longitude: position.longitude,
          markerId: "me",
          iconPath: "/customLocationIconsFolder/Me.png"
        );
        context.read<LoactionIconMapViewmodel>().addMarker(model);


      });

      // Harita kontrolcüsünü kullanarak anlık konuma odaklan
      final GoogleMapController controller = await _controller.future;
      controller
          .animateCamera(CameraUpdate.newCameraPosition(_initialPosition!));
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
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
              child: viewmodel!.isLoadingAllMarker
                  ? Stack(
                      children: [
                        Consumer<LoactionIconMapViewmodel>(
                          builder: (context, value, child) => GoogleMap(
                            onTap: (argument) {
                              if (value.selectLocation) {
                                LatLng location = LatLng(
                                    argument.latitude, argument.longitude);
                                _loadCustomMarker(location);
                              }
                              value.setSelectLocation(false);
                            },
                            mapType: MapType.normal,
                            markers: value.markerList,
                            initialCameraPosition:
                                _initialPosition!, // Dinamik başlangıç pozisyonu
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                          ),
                        ),
                        Provider.of<LoactionIconMapViewmodel>(context)
                                .selectLocation
                            ? Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                      padding: const EdgeInsets.all(10),
                                      color: Colors.white,
                                      child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: const CustomLoadingWidget())),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    )
                  : const Center(
                      child: CustomLoadingWidget(),
                    )),
          Container(
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                AppTheme.themeData.colorScheme.primary,
                Colors.white,
              ],
            )),
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
                    onTap: () {
                      _showIconsModal(context);
                    },
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

  void _showIconsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (modalContext) => IconPickerModal(
        onIconSelected: (int price, String iconPath, BuildContext modalContext) {
          _selectLocationIcon(price, iconPath, modalContext);
        },
      ),
    );
  }
}


