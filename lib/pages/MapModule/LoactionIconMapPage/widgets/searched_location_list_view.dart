import 'package:flutter/material.dart';
import 'package:moto_kent/services/geolacator_service_impl.dart';

class SearchedLocationListView extends StatelessWidget {
  const SearchedLocationListView(
      {super.key, required this.placePredictions, required this.onTap});

  final List<PlacePrediction> placePredictions;
  final Function(int) onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
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
        itemCount: placePredictions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(placePredictions[index].description),
            dense: true,
            onTap: () => onTap(index),
          );
        },
      ),
    );
  }
}
