import 'package:flutter/material.dart';
import 'package:moto_kent/components/category_dropdown.dart';
import 'package:moto_kent/components/turkey_province_dropdown.dart';

import 'package:moto_kent/pages/ExploreModule/ExplorePage/explore_viewmodel.dart';
import 'package:provider/provider.dart';


class FilterDialog extends StatefulWidget {


  const FilterDialog({super.key,  });

  @override
  FilterDialogState createState() => FilterDialogState();
}

class FilterDialogState extends State<FilterDialog> {
  String? selectedGender;
  int? minAge;
  int? maxAge;

  int? seciliKategori;
  int? plateCode;

  

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Filtreleri Seç"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cinsiyet Seçimi
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Cinsiyet"),
              value: selectedGender,
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                });
              },
              items: const [
                DropdownMenuItem(value: "Kadın", child: Text("Kadın")),
                DropdownMenuItem(value: "Erkek", child: Text("Erkek")),
                DropdownMenuItem(value: "Tümü", child: Text("Tümü")),
              ],
            ),
            const SizedBox(height: 10),

            // Yaş Aralığı Seçimi
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: "Min Yaş"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        minAge = int.tryParse(value);
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: "Max Yaş"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        maxAge = int.tryParse(value);
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

           TurkeyProvinceDropDown(
              plateCode: plateCode,
              onChanged: (value) {
                setState(() {
                  plateCode = value;
                });
              },
            ),
            const SizedBox(height: 10),
            CategoryDropDown(onChanged: (p0) {
              setState(() {
                seciliKategori = p0;
              });
            }, seciliKategori: seciliKategori),
              Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: (bool? value) {
                    setState(() {
                      //rememberSelection = value ?? false;
                    });
                  },
                ),
                const Text("Seçimi Hatırla"),
              ],
            ),
            
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("İptal"),
        ),
        ElevatedButton(
          onPressed: () async{

            await context.read<ExploreViewmodel>().fetchPostList2(category: seciliKategori, city: plateCode);
            Navigator.pop(context);
          },
          child: const Text("Uygula"),
        ),
      ],
    );
  }
}

// 🔥 Filtreleme Diyalogunu Açan Fonksiyon
void showFilterDialog(BuildContext context, ) {
  showDialog(
    context: context,
    builder: (context) => FilterDialog(),
  );
}
