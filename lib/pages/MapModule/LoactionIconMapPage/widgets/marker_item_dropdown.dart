

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/custom_marker_model.dart';
import 'package:moto_kent/utils/utils.dart';

class MarkerItemDropdown extends StatelessWidget {
  const MarkerItemDropdown({
    super.key,required this.filteredMarkers,this.onMarkerSelected
  });
  final List<CustomMarkerModel> filteredMarkers;
  final Function(CustomMarkerModel)? onMarkerSelected;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<CustomMarkerModel>(
        dropdownStyleData: DropdownStyleData(
          width: 280,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          offset: const Offset(-20, 8),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 90,
          padding: EdgeInsets.symmetric(horizontal: 12),
        ),
        customButton: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(
            Icons.category,
            size: 30,
            color: Colors.black,
          ),
        ),
        items: filteredMarkers.map((marker) {
          return DropdownMenuItem<CustomMarkerModel>(

            value: marker,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Image.network(
                    "${ApiConstants.baseUrl}/${marker.iconPath}" ,
                    width: 40,
                    height: 40,
                    errorBuilder: (_, __, ___) => const Icon(Icons.location_on),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          marker.iconName ?? 'Unknown Marker',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        if (marker.price != null)
                          Text(
                            'Price: \$${marker.price!.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        if (marker.uploadedDate != null)
                          Text(
                            "Uploaded:${ Utils.formatDateToDayMonthYear(marker.uploadedDate!)}",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null && onMarkerSelected != null) {
            onMarkerSelected!(value);
          }
        },

      ),
    );
  }
}
