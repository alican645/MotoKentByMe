import 'package:flutter/material.dart';
import 'package:moto_kent/components/category_dropdown.dart';
import 'package:moto_kent/components/custom_app_bar_widget.dart';
import 'package:moto_kent/components/custom_app_button.dart';
import 'package:moto_kent/constants/enums.dart';
import 'package:moto_kent/pages/ExploreModule/PostSharing/post_sharing_view_mixin.dart';
import 'package:moto_kent/pages/ExploreModule/PostSharing/post_sharing_viewmodel.dart';
import 'package:moto_kent/pages/ExploreModule/PostSharing/widgets/anket_ilan_add_button.dart';
import 'package:moto_kent/pages/ExploreModule/PostSharing/widgets/ilan_photo_tab_view.dart';
import 'package:moto_kent/utils/utils.dart';
import 'package:provider/provider.dart';

class PostSharingView extends StatefulWidget {
  const PostSharingView({super.key});

  @override
  State<PostSharingView> createState() => _PostSharingViewState();
}

class _PostSharingViewState extends State<PostSharingView>
    with PostSharingViewMixin {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<PostSharingViewmodel>().getCityName();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    contentTitleContreller.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar22(
        right: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: fromKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Utils.formatDateToDayMonthYear(DateTime.now()),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Provider.of<PostSharingViewmodel>(context).city == null
                        ? const SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator())
                        : Row(
                            children: [
                              Text(
                                Provider.of<PostSharingViewmodel>(context)
                                    .city!,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const Icon(Icons.location_on_outlined)
                            ],
                          ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                CategoryDropDown(
                  seciliKategori: seciliKategori,
                  onChanged: (value) {
                    setState(() => seciliKategori = value);
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  maxLength: 100,
                  controller: contentTitleContreller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Gönderi başlığınızı giriniz..",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Kategoriyi boş bırakmayınız';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Gönderi içeriğinizi giriniz..",
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Kategoriyi boş bırakmayınız';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
                if (seciliKategori == PostCategoryEnum.anket.index) ...[
                  const SizedBox(height: 20),
                  const Text('Anket Seçenekleri',
                      style: TextStyle(fontSize: 16)),
                  ...anketControllers.asMap().entries.map((entry) {
                    int index = entry.key;
                    TextEditingController controller = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller,
                              decoration: InputDecoration(
                                labelText: 'Seçenek ${index + 1}',
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? 'Seçenek boş olamaz' : null,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.red),
                            onPressed: () => anketSil(index),
                          ),
                        ],
                      ),
                    );
                  }),
                  AnketIlanAddButton(onPressed: anketEkle, text: 'Seçenek Ekle')
                ],
                if (seciliKategori == PostCategoryEnum.ilan.index) ...[
                  AnketIlanAddButton(onPressed: pickImage, text: 'Resim Ekle'),
                  if (selectedImages.isNotEmpty)
                    IlanPhotoTabView(
                        onPressed: (p0) {
                          setState(() {
                            selectedImages.removeAt(p0);
                          });
                        },
                        selectedImages: selectedImages),
                ],
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: CustomAppButton(
                      btnWidth: MediaQuery.sizeOf(context).width / 4,
                      onPressed: () {
                        submit();
                      },
                      btnText: paylasBtnTxt),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
