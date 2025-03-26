import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/components/custom_app_bar_widget.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/models/location_model.dart';
import 'package:moto_kent/pages/MapModule/LoactionIconMapPage/loaction_icon_map_viewmodel.dart';
import 'package:moto_kent/pages/MapModule/LoactionIconMapPage/location_icon_map_view_mixin.dart';
import 'package:moto_kent/pages/MapModule/LoactionIconMapPage/widgets/map_view_bottom_bar.dart';
import 'package:moto_kent/pages/MapModule/LoactionIconMapPage/widgets/marker_item_dropdown.dart';
import 'package:moto_kent/pages/MapModule/LoactionIconMapPage/widgets/search_location_text_field.dart';
import 'package:moto_kent/pages/MapModule/LoactionIconMapPage/widgets/searched_location_list_view.dart';
import 'package:provider/provider.dart';

class LocationIconMapView extends StatefulWidget {
  const LocationIconMapView({super.key, this.arg});

  final Map<String, dynamic>? arg;

  @override
  State<LocationIconMapView> createState() => _LocationIconMapViewState();
}

class _LocationIconMapViewState extends State<LocationIconMapView>
    with LoactionIconMapViewMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.arg?["callForHelpLatLangModel"] != null) {
        context.read<LoactionIconMapViewmodel>().addMarker(
            marker,
            widget.arg!["callForHelpLatLangModel"]!,
            widget.arg!["callForHelpLatLangModel"]!.iconPath!);
        context.read<LoactionIconMapViewmodel>().setInitialLocation(
            isCallForHelp: true,
            LatLng(widget.arg!["callForHelpLatLangModel"]!.latitude!,
                widget.arg!["callForHelpLatLangModel"]!.longitude!));
        context.read<LoactionIconMapViewmodel>().fetchAllLocations(marker);
      } else {
        context
            .read<LoactionIconMapViewmodel>()
            .setInitialLocation(isCallForHelp: false, null);
        context.read<LoactionIconMapViewmodel>().fetchAllLocations(marker);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchControler.dispose();
    locationCommentController.dispose();
  }

  @override
  // Kullanıcının yorum yapabileceği dialogu gösteren fonksiyon
  Future<void> showCommentDialog() async => showDialog(
        context: context,
        barrierDismissible:
            false, // Kullanıcı dialog dışına tıklayarak kapatamaz
        builder: (BuildContext contextt) {
          return AlertDialog(
            title: const Text('Yorum Yap'),
            content: TextField(
              controller: locationCommentController,
              minLines: 5,
              onChanged: (value) {
                locationComment = value;
              },
              decoration: const InputDecoration(
                hintText: 'Yorumunuzu girin...',
              ),
              maxLines: null, // Çok satırlı yorum girişine izin verir
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // İptal butonuna basıldığında dialog kapatılır
                  contextt
                      .read<LoactionIconMapViewmodel>()
                      .setLocationIsSelected(false);
                  locationCommentController.clear();

                  Navigator.of(contextt).pop();
                },
                child: const Text('İptal'),
              ),
              TextButton(
                onPressed: () {
                  contextt
                      .read<LoactionIconMapViewmodel>()
                      .setLocationIsSelected(true);
                  Navigator.of(contextt).pop();
                },
                child: const Text('Tamam'),
              ),
            ],
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<LoactionIconMapViewmodel>(
      builder: (context, viewmodel, child) {
        return Scaffold(
          appBar: CustomAppBar22(
            actions: [
              MarkerItemDropdown(
                filteredMarkers: viewmodel.modelList,
                onMarkerSelected: (p0) {
                  viewmodel.fetchAllLocationsByCategoryId(p0.id!, marker);
                },
              )
            ],
          ),
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height -
                  (MediaQuery.sizeOf(context).height * 0.18),
              child: Column(
                children: [
                  // Arama TextField
                  SearchLocationTextField(
                    searchControler: searchControler,
                    onChanged: (p0) => viewmodel.konumAra(p0),
                  ),
                  // Google Harita
                  Flexible(
                    child: Stack(
                      children: [
                        if (viewmodel.currentLocation == null ||
                            viewmodel.initialFlag == false)
                          const CustomLoadingWidget()
                        else
                          GoogleMap(
                            onTap: (argument) {
                              if (viewmodel.locationIsSelected) {
                                LatLng location = LatLng(
                                  argument.latitude,
                                  argument.longitude,
                                );
                                loadCustomMarker(location);
                              }
                              viewmodel.setLocationIsSelected(false);
                            },
                            myLocationEnabled: true,
                            mapToolbarEnabled: true,
                            polylines: viewmodel.polylines,
                            mapType: MapType.normal,
                            markers: viewmodel.markerList,
                            initialCameraPosition: CameraPosition(
                                target: viewmodel.currentLocation!, zoom: 40),
                            onMapCreated:
                                (GoogleMapController controllerr) async {
                              if (!controller.isCompleted) {
                                controller.complete(controllerr);
                              }
                            },
                          ),
                        if (viewmodel.locationIsSelected == true)
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                color: Colors.white,
                                child: const SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CustomLoadingWidget(),
                                ),
                              ),
                            ),
                          ),

                        if (viewmodel.isStartLocationTracking == true)
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: GestureDetector(
                              onTap: () async {
                                context
                                    .read<LoactionIconMapViewmodel>()
                                    .stopLocationTracking();
                              },
                              child: Container(
                                width: 100,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: AppTheme.themeData.primaryColor,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "İptal Et",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        // Arama Sonuç Listesi
                        if (viewmodel.placePredictions.isNotEmpty)
                          SearchedLocationListView(
                            placePredictions: viewmodel.placePredictions,
                            onTap: (p0) async {
                              await context
                                  .read<LoactionIconMapViewmodel>()
                                  .getLocationDetail(
                                      viewmodel.placePredictions[p0].placeId,
                                      controller)
                                  .then(
                                (value) async {
                                  if (value == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "İlgili adrese gidilemedi!")));
                                  } else {
                                    LocationModel model = LocationModel(
                                        iconPath: null,
                                        markerId: "searchedLocation",
                                        latitude: value.lat,
                                        longitude: value.lng,
                                        comment: value.formattedAddress);
                                    viewmodel.addMarker(
                                        marker, model, model.iconPath!);
                                    await goToSerachedLocation(
                                        LatLng(value.lat!, value.lng!));
                                  }
                                },
                              );
                            },
                          )
                      ],
                    ),
                  ),

                  // Alt buton çubuğu
                  MapViewBottomBar(
                    myLocationMapIconOnPressed: goToCurrentLocation,
                    showIconsModalOnTap: () => showIconsModal(context),
                    refreshMapOnPressed: () async =>
                        await viewmodel.fetchAllLocations(marker),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Marker marker(LocationModel location, Uint8List byteData) => Marker(
      infoWindow: InfoWindow(
        title: "Kullanıcı Yorumu:",
        snippet: location.comment,
        onTap: () {
          showDialog(
            context: context,
            builder: (contextt) => AlertDialog(
              actions: [
                TextButton(
                    onPressed: () async {
                      await getRoute(location);
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
      icon: BitmapDescriptor.bytes(byteData, height: 48, width: 48));
}
