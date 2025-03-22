import 'package:flutter/material.dart';
import 'package:moto_kent/app/app_theme.dart';
import 'package:moto_kent/pages/MapModule/LoactionIconMapPage/widgets/map_icon.dart';

class MapViewBottomBar extends StatelessWidget {
  const MapViewBottomBar(
      {super.key,
      required this.myLocationMapIconOnPressed,
      required this.refreshMapOnPressed,
      required this.showIconsModalOnTap});
  final VoidCallback myLocationMapIconOnPressed;
  final VoidCallback refreshMapOnPressed;
  final VoidCallback showIconsModalOnTap;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              onPressed: myLocationMapIconOnPressed,
              iconData: Icons.my_location_outlined,
            ),
            GestureDetector(
              onTap: showIconsModalOnTap,
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
              onPressed: refreshMapOnPressed,
            ),
          ],
        ),
      ),
    );
  }
}
