import 'package:flutter/material.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/pages/CallForHelpPage/call_for_help_viewmodel.dart';
import 'package:moto_kent/services/firebase_notification_service.dart';
import 'package:provider/provider.dart';

class CallForHelpView extends StatefulWidget {
  const CallForHelpView({super.key});

  @override
  State<CallForHelpView> createState() => _CallForHelpViewState();
}

class _CallForHelpViewState extends State<CallForHelpView> {


  @override
  void initState(){
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            "Çağrınız yakınınızda bulunan diğer kullanıcılara ulaşacaktır !",
            textAlign: TextAlign.center,
            maxLines: 3,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20,),
          CallForHelpViewItem(
            path: "assets/images/kaza_yardimi.png",
            explanation: "Sorun Yardımı",
            onPressed: () {
              print("sorun yardımı");
            },
          ),
          SizedBox(height: 20,),
          CallForHelpViewItem(
            path: "assets/images/sorun_yardimi.png",
            explanation: "Kaza Yardımı",
            onPressed: ()  async {
              print("Kaza yardımı");

              await context.read<CallForHelpViewmodel>().callForHelp();

            },
          ),
          SizedBox(height: 20,),
          CallForHelpViewItem(
            path: "assets/images/beni_bul.png",
            explanation: "Beni Bul",
            onPressed: () {
              print("Beni bul");

            },
          ),
          SizedBox(height: 20,),
        ],
      ),
    ));
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
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(45),
              border: Border.all(
                  width: 2, color: AppTheme.themeData.primaryColor)),
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
