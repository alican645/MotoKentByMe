import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/location_model.dart';
import 'package:moto_kent/pages/MapModule/LoactionIconMapPage/loaction_icon_map_view.dart';
import 'package:moto_kent/pages/MapModule/LoactionIconMapPage/loaction_icon_map_viewmodel.dart';
import 'package:moto_kent/pages/MapModule/LoactionIconMapPage/widgets/gridview_bottom_modal_sheet.dart';
import 'package:provider/provider.dart';

mixin LoactionIconMapViewMixin on State<LocationIconMapView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Completer<GoogleMapController> get controller => _controller;

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchControler => _searchController;
  final TextEditingController _locationCommentController =
      TextEditingController();
  TextEditingController get locationCommentController =>
      _locationCommentController;
  String? iconPath;
  int? iconId;
  String? locationComment;

  Future<void> showCommentDialog();
  Marker marker(LocationModel location, Uint8List byteData);

  Future<void> selectLocationIcon(int selectIconId, String selectIconPath,
      BuildContext selectContext) async {
    iconPath = selectIconPath;
    iconId = selectIconId;
    Navigator.pop(selectContext);
    showCommentDialog().then(
      (value) async {
        if (!mounted) return;
      },
    );
  }

  Future<void> getRoute(
    LocationModel location,
  ) async =>
      await context.read<LoactionIconMapViewmodel>().getRoute(location);

  Future<void> goToCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      final GoogleMapController controller = await _controller.future;

      await controller.animateCamera(
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

  Future<void> goToSerachedLocation(LatLng location) async {
    try {
      if (!mounted) return;
      final GoogleMapController controller = await _controller.future;
      await controller.animateCamera(
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
  Future<void> loadCustomMarker(LatLng location) async {
    var prefs = LocalStorageImpl();
    String? userId = await prefs.getValue<String>("user_id");

    LocationModel model = LocationModel()
      ..longitude = location.longitude
      ..latitude = location.latitude
      ..markerId =
          "${location.latitude}/${location.longitude}/${DateTime.now()}"
      ..userId = userId
      ..customLocationIconId = iconId
      ..comment = locationCommentController.text;

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
        await viewmodel.addMarker(marker, model, iconPath!);
        locationCommentController.clear();
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

  void showIconsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (modalContext) => IconPickerModal(
        onIconSelected: (int id, String path, BuildContext ctx) {
          selectLocationIcon(id, path, ctx);
        },
      ),
    );
  }
}
