  import 'dart:async';

  import 'package:dropdown_button2/dropdown_button2.dart';
  import 'package:flutter/material.dart';
  import 'package:google_maps_flutter/google_maps_flutter.dart';
  import 'package:geolocator/geolocator.dart';
  import 'package:moto_kent/App/app_theme.dart';
  import 'package:moto_kent/components/custom_app_bar_widget.dart';
  import 'package:moto_kent/components/custom_loading_widget.dart';
  import 'package:moto_kent/constants/api_constants.dart';
  import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
  import 'package:moto_kent/models/custom_marker_model.dart';
  import 'package:moto_kent/models/location_model.dart';
  import 'package:moto_kent/pages/MapModule/LoactionIconMapPage/loaction_icon_map_viewmodel.dart';
  import 'package:moto_kent/pages/MapModule/LoactionIconMapPage/widgets/custom_category_dropdown.dart';
  import 'package:moto_kent/pages/MapModule/LoactionIconMapPage/widgets/gridview_bottom_modal_sheet.dart';
  import 'package:moto_kent/pages/MapModule/LoactionIconMapPage/widgets/map_icon.dart';
  import 'package:moto_kent/pages/MapModule/LoactionIconMapPage/widgets/marker_item_dropdown.dart';
  import 'package:provider/provider.dart';

  class LocationIconMapView extends StatefulWidget {
    const LocationIconMapView({super.key});

    @override
    State<LocationIconMapView> createState() => _LocationIconMapViewState();
  }

  class _LocationIconMapViewState extends State<LocationIconMapView> {
    // Harici TextEditingController
    final TextEditingController _searchController = TextEditingController();
    final TextEditingController _locationCommentController = TextEditingController();
    String? iconPath;
    int? iconId;
    String? locationComment;




    @override
    void initState() {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<LoactionIconMapViewmodel>().fetchAllLocations(context);
        context.read<LoactionIconMapViewmodel>().setInitialLocation();

      });
    }

    @override
    void dispose(){
      super.dispose();
      _searchController.dispose();
      _locationCommentController.dispose();

    }

    Future<void> _selectLocationIcon(
        int selectIconId, String selectIconPath, BuildContext selectContext) async {
      iconPath = selectIconPath;
      iconId = selectIconId;
      Navigator.pop(selectContext);
      _showCommentDialog(context).then((value) async {
        if(!mounted) return;
        context.read<LoactionIconMapViewmodel>().setSelectLocation(true);
      },);

    }

    // Kullanıcının yorum yapabileceği dialogu gösteren fonksiyon
    Future<void> _showCommentDialog(BuildContext context) async {
      showDialog(
        context: context,
        barrierDismissible: false, // Kullanıcı dialog dışına tıklayarak kapatamaz
        builder: (BuildContext contextt) {
          return AlertDialog(
            title: const Text('Yorum Yap'),
            content: TextField(
              controller: _locationCommentController,
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
                  _locationCommentController.clear();
                  context.read<LoactionIconMapViewmodel>().setSelectLocation(false);
                  Navigator.of(contextt).pop();
                },
                child: const Text('İptal'),
              ),
              TextButton(
                onPressed: () {

                  Navigator.of(contextt).pop();
                },
                child: const Text('Tamam'),
              ),
            ],
          );
        },
      );
    }

    Future<void> _goToCurrentLocation() async {
      try {
        Position position = await Geolocator.getCurrentPosition();
        if (!mounted) return;
        final GoogleMapController controller =
            await context.read<LoactionIconMapViewmodel>().controller.future;

        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 20,
            ),
          ),
        );
      } catch (e) {
        debugPrint("Konum hatası: $e");
      }
    }
    Future<void> _goToSerachedLocation(LatLng location) async {
      try {
        if (!mounted) return;
        final GoogleMapController controller =
            await context.read<LoactionIconMapViewmodel>().controller.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(location.latitude, location.longitude),
              zoom: 20,
            ),
          ),
        );
      } catch (e) {
        debugPrint("Konum hatası: $e");
      }
    }

    /// Marker ekleme isteği atma
    Future<void> _loadCustomMarker(LatLng location) async {
      var prefs = LocalStorageImpl();
      String? userId = await prefs.getValue<String>("user_id");

      LocationModel model = LocationModel()
        ..longitude = location.longitude
        ..latitude = location.latitude
        ..markerId = "${location.latitude}/${location.longitude}/${DateTime.now()}"
        ..userId = userId
        ..customLocationIconId = iconId
        ..comment=_locationCommentController.text;

      try {
        if (!mounted) return;
        final viewmodel = context.read<LoactionIconMapViewmodel>();
        var response = await viewmodel.createMarker(model);
        if (response.statusCode != 200) {

          if (!mounted) return;
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(response.data.toString()),
            ),
          );
        } else {
          if (!mounted) return;
          await viewmodel.addMarker( context, model,  iconPath!);
          _locationCommentController.clear();
        }
      } catch (e) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }

    void _showIconsModal(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (modalContext) => IconPickerModal(
          onIconSelected: (int id, String path, BuildContext ctx) {
            _selectLocationIcon(id, path, ctx);
          },
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Consumer<LoactionIconMapViewmodel>(
        builder: (context, viewmodel, child) {
          return Scaffold(
            appBar: CustomAppBar22(
              actions: [
                MarkerItemDropdown(filteredMarkers: viewmodel.modelList,onMarkerSelected:  (p0) {
                  viewmodel.fetchAllLocationsByCategoryId(context, p0.id!);
                },)
               ],
            ),
              resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              physics:const  NeverScrollableScrollPhysics(),
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height-(MediaQuery.sizeOf(context).height*0.18),
                child: Column(
                  children: [
                    // Arama TextField
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => viewmodel.konumAra(val),
                        decoration: const InputDecoration(
                          hintText: 'Konum ara...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    // Google Harita
                    Expanded(
                      child: Stack(
                        children: [

                          if ( viewmodel.currentLocation==null)
                            const CustomLoadingWidget()
                          else
                            GoogleMap(
                              onTap: (argument) {
                                if (viewmodel.selectLocation) {
                                  LatLng location = LatLng(
                                    argument.latitude,
                                    argument.longitude,
                                  );
                                  _loadCustomMarker(location);
                                }
                                viewmodel.setSelectLocation(false);
                              },
                              myLocationEnabled: true,
                              mapToolbarEnabled: true,
                              polylines: viewmodel.polylines,
                              mapType: MapType.normal,
                              markers: viewmodel.markerList,
                              initialCameraPosition: CameraPosition(target: viewmodel.currentLocation!,zoom: 40),
                              onMapCreated: (GoogleMapController controller) async {
                                viewmodel.controller.complete(controller);
                              },
                            ), Provider.of<LoactionIconMapViewmodel>(context)
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
                          if(viewmodel.isStartLocationTracking==true)
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: GestureDetector(
                                onTap: () async{
                                  context.read<LoactionIconMapViewmodel>().stopLocationTracking();
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
                          if(viewmodel.initialFlag==false)Align(alignment: Alignment.bottomCenter,child: LinearProgressIndicator()),
                          // Arama Sonuç Listesi
                          if (viewmodel.placePredictions.isNotEmpty)
                            Container(
                              height: 200,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: ListView.builder(
                                itemCount: viewmodel.placePredictions.length,
                                itemBuilder: (context, index) {
                                  final place = viewmodel.placePredictions[index];
                                  return ListTile(
                                    title: Text(place['description'] ?? ""),
                                    dense: true,
                                    onTap: () async {

                                      await context.read<LoactionIconMapViewmodel>().getLocationDetail(place['place_id']).then((value) async {
                                        if(value==null){
                                          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("İlgili adrese gidilemedi!")));
                                        }else{
                                          LocationModel model = LocationModel(
                                            iconPath: null,
                                            markerId: "searchedLocation",
                                            latitude: value.lat,
                                            longitude: value.lng,
                                            comment: value.formattedAddress
                                          );
                                          viewmodel.addMarker(context,  model,model.iconPath!);
                                          await _goToSerachedLocation(LatLng(value.lat!, value.lng!));
                                        }
                                      },);
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),




                    // Alt buton çubuğu
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppTheme.themeData.colorScheme.primary,
                            Colors.white,
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MapIcon(
                              onPressed: _goToCurrentLocation,
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
                                await viewmodel.fetchAllLocations(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }





