import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/constants/enums.dart';
import 'package:moto_kent/pages/CallForHelpPage/call_for_help_viewmodel.dart';
import 'package:provider/provider.dart';

class CallForHelpView extends StatefulWidget {
  const CallForHelpView({super.key});

  @override
  State<CallForHelpView> createState() => _CallForHelpViewState();
}

class _CallForHelpViewState extends State<CallForHelpView> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> sendCallForHelp(CallForHelpEnum callForEnum) async {
    try {
      var response = await context
          .read<CallForHelpViewmodel>()
          .sendCallForHelp(callForEnum);

      if (response.statusCode == 200) {
        var count=(response.data as Map<String,dynamic>)["nearbyCountUser"];
        Fluttertoast.showToast(
            msg:
                "Yardım çağırınız yakınınızda bulunan ${count} kişiye iletildi");
      }
    } catch (ex) {
      Fluttertoast.showToast(msg: 'Hata Yardım Çağırısı Gönderilemedi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<CallForHelpViewmodel>(
        builder: (context, value, child) => Column(
          children: [
            const Text(
              "Çağrınız yakınınızda bulunan diğer kullanıcılara ulaşacaktır !",
              textAlign: TextAlign.center,
              maxLines: 3,
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            value.isLoadingSY
                ? CallForHelpViewItem(
                    path: "assets/images/kaza_yardimi.png",
                    explanation: "Sorun Yardımı",
                    onPressed: () async {

                      sendCallForHelp(CallForHelpEnum.sorunYardim);

                    },
                  )
                : const CallForHelpViewItemProgressIndicator(),
            const SizedBox(
              height: 20,
            ),
            value.isLoadingKY
                ? CallForHelpViewItem(
                    path: "assets/images/sorun_yardimi.png",
                    explanation: "Kaza Yardımı",
                    onPressed: () async {
                      print("Kaza yardımı");


                      sendCallForHelp(CallForHelpEnum.kazaYardim);
                    },
                  )
                : const CallForHelpViewItemProgressIndicator(),
            const SizedBox(
              height: 20,
            ),
            value.isLoadingBB
                ? CallForHelpViewItem(
                    path: "assets/images/beni_bul.png",
                    explanation: "Beni Bul",
                    onPressed: () async {

                      sendCallForHelp(CallForHelpEnum.beniBul);

                    },
                  )
                : const CallForHelpViewItemProgressIndicator(),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ));
  }
}

class CallForHelpViewItemProgressIndicator extends StatelessWidget {
  const CallForHelpViewItemProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: 150,
        height: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45),
            border:
                Border.all(width: 2, color: AppTheme.themeData.primaryColor)),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class CallForHelpViewCountItem extends StatelessWidget {
  const CallForHelpViewCountItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: 150,
        height: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45),
            border:
                Border.all(width: 2, color: AppTheme.themeData.primaryColor)),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class CallForHelpViewItem extends StatelessWidget {
  const CallForHelpViewItem(
      {super.key,
      required this.path,
      required this.explanation,
      required this.onPressed});
  final String path;
  final String explanation;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 150,
          height: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(45),
              border:
                  Border.all(width: 2, color: AppTheme.themeData.primaryColor)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Flexible(
                  child: Image.asset(
                    path,
                    fit: BoxFit.fill,
                    width: MediaQuery.sizeOf(context).width / 4,
                  ),
                ),
                Text(explanation)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
