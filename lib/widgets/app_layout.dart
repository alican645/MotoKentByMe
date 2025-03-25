import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/services/current_laciton_service.dart';
import 'package:moto_kent/services/api_service_impl.dart';
import 'package:moto_kent/services/firebase_notification_service.dart';
import '../App/app_theme.dart';

class AppLayout extends StatefulWidget {
  final StatefulNavigationShell statefulNavigationShell;

  const AppLayout({super.key, required this.statefulNavigationShell});

  @override
  _AppLayoutState createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  final FirebaseNotificationService _notificationService =
      FirebaseNotificationService();

  @override
  void initState() {
    super.initState();
    initializeSetLastLocation().then(
      (value) {
        _notificationService.connectNotification().then(
          (value) {
            addDeviceTokenToUser();
          },
        );
      },
    );
  }

  Future<void> initializeSetLastLocation() async {
    await CurrentLacitonService().initialize();
  }

  Future<void> addDeviceTokenToUser() async {
    await Future.delayed(const Duration(seconds: 3));

    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    ApiServiceImpl service = ApiServiceImpl();

    try {
      var response = await service.postRequest(
          ApiConstants.addDeviceTokenToUser,
          jsonEncode({
            "userId": userId,
            "deviceToken": _notificationService.deviceToken
          }));
      if (response.statusCode == 200) {
        log("güncelleme başarılı", name: "isSuccess");
      } else {
        log(response.data, name: "isNotSuccess");
      }
    } catch (e) {
      log(e.toString(), name: "isNotSuccess");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tüm sayfalarda yenileme özelliği için RefreshIndicator ile sarılı body
      body: widget.statefulNavigationShell,

      // Gradient arka planlı BottomNavigationBar
      bottomNavigationBar: Container(
        color: AppTheme.themeData.colorScheme.primary,
        child: BottomNavigationBar(
          currentIndex: widget.statefulNavigationShell.currentIndex,
          onTap: (index) => widget.statefulNavigationShell.goBranch(index),
          backgroundColor: Colors.transparent,
          selectedItemColor: Theme.of(context).colorScheme.onSurface,
          unselectedItemColor: Theme.of(context).colorScheme.surface,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: 28,
          items: [
            _buildNavBarItem(context, Icons.home_outlined, 0),
            _buildNavBarItem(context, Icons.navigation_outlined, 1),
            _buildNavBarItem(context, Icons.health_and_safety_outlined, 2),
            _buildNavBarItem(context, Icons.menu, 3),
            _buildNavBarItem(context, Icons.person_2_outlined, 4),
          ],
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavBarItem(
      BuildContext context, IconData iconData, int index) {
    return BottomNavigationBarItem(
      icon: Icon(iconData),
      label: "",
    );
  }
}
