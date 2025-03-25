import 'dart:io';

import 'package:flutter/material.dart';

class IlanPhotoTabView extends StatelessWidget {
  const IlanPhotoTabView({
    super.key,
    required List<File> selectedImages,
    required Function(int) onPressed,
  })  : _selectedImages = selectedImages,
        _onPressed = onPressed;

  final List<File> _selectedImages;
  final Function(int) _onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.width * 0.85,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _selectedImages.asMap().entries.map(
              (e) {
                return Container(
                  margin: EdgeInsets.all(8),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: Stack(children: [
                    Image.file(e.value, fit: BoxFit.cover),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                            onPressed: () => _onPressed(e.key),
                            icon: const Icon(
                              Icons.cancel_outlined,
                              size: 30,
                            ))),
                  ]),
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}
