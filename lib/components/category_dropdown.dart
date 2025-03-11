

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/enums.dart';

class CategoryDropDown extends StatelessWidget {
  const CategoryDropDown({
    super.key, 
     this.seciliKategori, 
    required this.onChanged,
  });

  final int? seciliKategori;
  final Function(int?) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<int>(
                  // Değer olarak categoryId (int) kullanıyoruz
                  decoration:const InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(),
                  ),
                  value: seciliKategori, // int? tipinde olmalı
                  items: PostCategoryEnum.values.map((PostCategoryEnum value) {
                    return DropdownMenuItem<int>(
                      value: value.categoryId,
                      child: Text(value.isim),
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