import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../App/app_theme.dart';

class AppLayout extends StatefulWidget {
  final StatefulNavigationShell statefulNavigationShell;

  AppLayout({Key? key, required this.statefulNavigationShell}) : super(key: key);

  @override
  _AppLayoutState createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  Key _navigationKey = UniqueKey(); // Sayfa yenilendiğinde widget'ı yeniden oluşturmak için key

  // Sayfa yenileme işlemi
  Future<void> _onRefresh() async {
    setState(() {
      // Yeni bir key atayarak tüm `statefulNavigationShell` widget'ını yeniden oluşturuyoruz
      _navigationKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.themeData.colorScheme.primary,
                Colors.white,
              ],
            ),
          ),
          child: AppBar(
            title: Image.asset(
              'assets/images/moto_kent_logo.png', // Resminizin assets klasöründeki yolu
              height: 60, // Resim yüksekliğini ayarlayın
              fit: BoxFit.fitWidth,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
                tooltip: 'Search',
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.menu),
                tooltip: 'Menu',
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.star),
                tooltip: 'Favorites',
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.message),
                tooltip: 'Messages',
              ),
            ],
          ),
        ),
      ),

      // Tüm sayfalarda yenileme özelliği için RefreshIndicator ile sarılı body
      body: Container(
        color: Colors.white,
        child: widget.statefulNavigationShell,
      ),

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
