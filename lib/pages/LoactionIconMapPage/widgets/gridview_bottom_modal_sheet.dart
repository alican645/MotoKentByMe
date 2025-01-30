

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/pages/LoactionIconMapPage/loaction_icon_map_viewmodel.dart';
import 'package:moto_kent/pages/ProfilePage/profile_page.dart';
import 'package:provider/provider.dart';

class IconPickerModal extends StatelessWidget {
  final Function(int id, String iconPath, BuildContext context)
  onIconSelected;

  const IconPickerModal({required this.onIconSelected, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoactionIconMapViewmodel>(
      builder: (context, value, child) => GridView.builder(
        padding: const EdgeInsets.all(25),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          childAspectRatio: 1.0,
        ),
        itemCount: value.modelList.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return IconButton(
              onPressed: () {
                context.push(
                  "/buy_coin_page"
                );
              },
              icon: Icon(
                Icons.monetization_on_outlined,
                color: AppTheme.themeData.primaryColor,
                size: 36,
              ),
            );
          }
          if (index == 1) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.monetization_on_outlined,
                  color: AppTheme.themeData.primaryColor,
                ),
                Text(
                  value.totalMarkerIconToken.toString(),
                  style: TextStyle(color: AppTheme.themeData.primaryColor),
                )
              ],
            );
          }

          return GestureDetector(
            onTap: () {
              onIconSelected(
                value.modelList[index - 2].id!,
                value.modelList[index - 2].iconPath!,
                context,
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Image.network(
                    '${ApiConstants.baseUrl}${value.modelList[index - 2].iconPath}',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Text(value.modelList[index - 2].iconName!),
                value.modelList[index - 2].price == 0
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Free",
                      style:
                      TextStyle(color: AppTheme.themeData.primaryColor),
                    ),
                  ],
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      value.modelList[index - 2].price.toString(),
                      style: TextStyle(
                          color: AppTheme.themeData.primaryColor),
                    ),
                    const SizedBox(width: 1),
                    Icon(Icons.monetization_on_outlined,
                        size: 20,
                        color: AppTheme.themeData.primaryColor),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
