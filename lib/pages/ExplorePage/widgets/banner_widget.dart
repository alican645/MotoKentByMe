import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/baanner_model.dart';
import 'package:moto_kent/pages/ExplorePage/explore_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AdSlider extends StatefulWidget {

  final double width;

   AdSlider({
    super.key,

    this.width = 200,
  });

  @override
  State<AdSlider> createState() => _AdSliderState();
}

class _AdSliderState extends State<AdSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;


  @override
  void initState(){
    super.initState();
    context.read<ExploreViewmodel>().fetchAllCurrentBanner();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExploreViewmodel>(builder: (context, value, child) =>
      SizedBox(
        width: widget.width,
        height: 150,
        child: 
        value.banners.isEmpty ? const Image(image: AssetImage("assets/images/motorlar2.png"),fit: BoxFit.fitWidth,): 
        Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: value.banners.length,
              itemBuilder: (context, index) {
                final ad = value.banners[index];
                return GestureDetector(
                  onTap: ()async {

                    await _openUrl(ad.navigatePath!);

                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage("${ApiConstants.baseUrl}/${ad.photoPath}"),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                );
              },
            ),

            // Sağ alt köşede sayı sayacı
            Positioned(
              bottom: 10,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentPage + 1}/${value.banners.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openUrl( String url) async {
    try{
      final Uri uri = Uri.parse(url);

      // Tarayıcı ayarları
      const mode = LaunchMode.externalApplication; // Harici tarayıcı

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,

        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tarayıcı açılamadı!')),
        );
      }
    }catch(e){
      log("reklam yönlendirme",error: e.toString());
    }

  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}


