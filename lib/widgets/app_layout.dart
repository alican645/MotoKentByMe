import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/services/current_laciton_service.dart';
import '../App/app_theme.dart';

class AppLayout extends StatefulWidget {
  final StatefulNavigationShell statefulNavigationShell;

  const AppLayout({super.key, required this.statefulNavigationShell});

  @override
  AppLayoutState createState() => AppLayoutState();
}

class AppLayoutState extends State<AppLayout> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        initializeSetLastLocation();
      },
    );
    super.initState();
  }

  Future<void> initializeSetLastLocation() async {
    await CurrentLacitonService().initialize();
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
