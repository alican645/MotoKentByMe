

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/enums.dart';

class TurkeyProvinceDropDown extends StatelessWidget {
  const TurkeyProvinceDropDown({
    super.key, 
     this.plateCode, 
    required this.onChanged,
  });

  final int? plateCode;
  final Function(int?) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<int>(
                  
                  decoration:const InputDecoration(
                    labelText: 'Şehir',
                    border: OutlineInputBorder(),
                  ),
                  value: plateCode, // int? tipinde olmalı
                  items: TurkeyProvince.values.map((TurkeyProvince value) {
                    return DropdownMenuItem<int>(
                      value: value.plateCode,
                      child: Text(value.provinceName),
                    );
                  }).toList(),
                  onChanged: (value) => onChanged(value),
                  validator: (value) {
                    if (value == null) {
                      return 'Kategoriyi boş bırakmayınız';
                    }
                    return null;
                  },
                );
  }
}