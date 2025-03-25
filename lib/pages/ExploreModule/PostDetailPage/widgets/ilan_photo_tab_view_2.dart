import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';

class IlanPhotoTabView2 extends StatelessWidget {
  const IlanPhotoTabView2({super.key, required List<String> selectedImages})
      : _selectedImages = selectedImages;
  final List<String> _selectedImages;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.85,
      height: MediaQuery.sizeOf(context).width * 0.85,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _selectedImages.asMap().entries.map(
            (e) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          insetPadding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 24.0),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 0),
                          content: InteractiveViewer(
                            minScale: 1.0, // Minimum zoom seviyesi
                            maxScale: 5.0, // Maksimum zoom seviyesi
                            child: Image.network(
                              '${ApiConstants.baseUrl}/${e.value}',
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Image.network('${ApiConstants.baseUrl}/${e.value}',
                      fit: BoxFit.cover),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
