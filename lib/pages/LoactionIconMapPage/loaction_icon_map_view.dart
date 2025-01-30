import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/models/location_model.dart';
import 'package:moto_kent/pages/LoactionIconMapPage/loaction_icon_map_viewmodel.dart';
import 'package:moto_kent/pages/LoactionIconMapPage/widgets/gridview_bottom_modal_sheet.dart';
import 'package:moto_kent/pages/LoactionIconMapPage/widgets/map_icon.dart';
import 'package:provider/provider.dart';



class LocationIconMapView extends StatefulWidget {
  const LocationIconMapView({super.key});

  @override
  State<LocationIconMapView> createState() => _LocationIconMapViewState();
}

class _LocationIconMapViewState extends State<LocationIconMapView> {

  Uint8List? customMarkerIconBytes;
  String? iconPath;
  int? iconId;


  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      initialize();
    },);
  }

  @override
  dispose() {
    super.dispose();

  }

  Future<void> initialize() async {

    await context.read<LoactionIconMapViewmodel>().initialize(context);


  }

  /// Marker'ı özelleştirme ve ekleme
  Future<void> _loadCustomMarker(
    LatLng location,
  ) async {
    var prefs = SharedPreferencesHelper();
    String? userId =await prefs.getValue<String>("user_id");

    LocationModel model = LocationModel()
      ..longitude = location.longitude
      ..latitude = location.latitude
      ..markerId =
          "${location.latitude}/${location.longitude}/${DateTime.now()}"
      ..userId = userId
      ..customLocationIconId=iconId;
try {
  if(!mounted) return;
  var response = await context.read<LoactionIconMapViewmodel>().createMarker(model);

  if(response.statusCode!=200) {
    if(!mounted) return;
    showDialog(context: context, builder: (sdcontext) {

      return AlertDialog(
        title: Text(response.data),
      );
    },);
  }else{
    if(!mounted) return;
    await context.read<LoactionIconMapViewmodel>().addMarker(model,iconPath!);
  }
}catch(e){
  if(!mounted) return;
  showDialog(context: context, builder: (sdcontext) {

    return AlertDialog(
      title: Text(e.toString()),
    );
  },);
}
  }

  Future<void> _selectLocationIcon(int selectIconId,
      String selectIconPath, BuildContext selectContext) async {
    iconPath = selectIconPath;
    iconId=selectIconId;
    Navigator.pop(selectContext);
    context.read<LoactionIconMapViewmodel>().setSelectLocation(true);
  }


  Future<void> _goToCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(

      );
      if(!mounted) return;
      final GoogleMapController controller = await context.read<LoactionIconMapViewmodel>().controller.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 20,
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
              child:
                  Stack(
                      children: [
                        Consumer<LoactionIconMapViewmodel>(
                          builder: (context, value, child) {
                            if(value.initialPosition==null || value.initialFlag==false){
                              return const CustomLoadingWidget();
                            }
                            return GoogleMap(
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
                            value.initialPosition!, // Dinamik başlangıç pozisyonu
                            onMapCreated: (GoogleMapController controller) {

                              value.controller.complete(controller);
                            },
                          );
                          },
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
                                      child: const SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: CustomLoadingWidget())),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    )
                 ),
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
                    onPressed: () async {
                        await context.read<LoactionIconMapViewmodel>().resetMap(context);

                    },
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
        onIconSelected: (int id, String iconPath, BuildContext modalContext) {
          _selectLocationIcon(id, iconPath, modalContext);
        },
      ),
    );
  }
}


