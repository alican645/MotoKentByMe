import 'package:flutter/material.dart';
import 'package:moto_kent/components/custom_app_bar.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/pages/ProfileModule/AboutPage/about_viewmodel.dart';
import 'package:provider/provider.dart';

class AboutView extends StatefulWidget {
  const AboutView({Key? key}) : super(key: key);

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  @override
  void initState() {
    super.initState();
    // Sayfa yüklendikten sonra verileri çekiyoruz
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AboutViewmodel>().fetchAbouts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Hakkımızda"),
      body: Consumer<AboutViewmodel>(
        builder: (context, aboutModel, child) {
          if (!aboutModel.islLoading) return const CustomLoadingWidget();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: aboutModel.list.length,
            itemBuilder: (context, index) {
              final section = aboutModel.list[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ana başlık
                      Text(
                        section.title ?? "",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),
                      // Başlık altındaki maddeler
                      ...List.generate(
                        section.aboutItems?.length ?? 0,
                            (i) {
                          final item = section.aboutItems![i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.content ?? "",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
