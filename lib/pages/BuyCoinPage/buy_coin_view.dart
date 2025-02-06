import 'package:flutter/material.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/components/custom_app_bar.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/models/app_marker_coin_price_and_count_model.dart';
import 'package:moto_kent/pages/BuyCoinPage/buy_coin_viewmodel.dart';
import 'package:provider/provider.dart';

class BuyCoinView extends StatelessWidget {
  const BuyCoinView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Jeton Satın Al",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
            future: context
                .read<BuyCoinViewmodel>()
                .getAppMarkerCoinPriceAndCountList(),
            builder: (context, snapshot) {
              if(snapshot.data==null){
                return const CustomLoadingWidget();
              }
              return GridView.builder(
              itemCount: snapshot.data!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) => BuyCoinButtonWidget(
                model: snapshot.data![index] ,
              ),
            );
            },),
      ),
    );
  }
}

class BuyCoinButtonWidget extends StatelessWidget {
  const BuyCoinButtonWidget({
    super.key,required this.model
  });
  final AppMarkerCoinPriceAndCountModel model;
  @override
  Widget build(BuildContext context) {
    TextStyle style = const TextStyle(fontSize: 18);
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 1.5, color: Colors.grey.shade500)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(model.appMarkerCoinCount.toString(),style: style,),
              Icon(
                Icons.monetization_on_outlined,
                color: AppTheme.themeData.primaryColor,
                size: 36,
              ),
            ],
          ),
          const SizedBox(height: 25,),
          Text("${model.appMarkerCoinPrice} TL",style: style,)
        ],
      ),
    );
  }
}
