import 'package:flutter/material.dart';

class SearchLocationTextField extends StatelessWidget {
  const SearchLocationTextField({
    super.key,
    required this.searchControler,
    required this.onChanged,
  });

  final TextEditingController searchControler;
  final Function(String) onChanged;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: searchControler,
        onChanged: (val) => onChanged(val),
        decoration: const InputDecoration(
          hintText: 'Konum ara...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
