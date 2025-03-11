import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moto_kent/components/category_dropdown.dart';
import 'package:moto_kent/components/custom_app_bar_widget.dart';
import 'package:moto_kent/components/custom_app_button.dart';
import 'package:moto_kent/constants/enums.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/post_model.dart';
import 'package:moto_kent/pages/ExploreModule/PostSharing/post_sharing_viewmodel.dart';
import 'package:moto_kent/utils/utils.dart';
import 'package:provider/provider.dart';

class PostSharingView extends StatefulWidget {
  const PostSharingView({super.key});

  @override
  State<PostSharingView> createState() => _PostSharingViewState();
}

class _PostSharingViewState extends State<PostSharingView> {
  final imagePicker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final paylasBtnTxt = "Paylaş";

  int? _seciliKategori;

  List<TextEditingController> _anketControllers = [TextEditingController()];
  List<SurveyItems> _surveyItems = [];
  String? selectedPostKategori;

  TextEditingController contentController = TextEditingController();
  TextEditingController contentTitleContreller = TextEditingController();
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

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    String content = contentController.text;
    String contentTitle = contentTitleContreller.text;
    String cityName =  Provider.of<PostSharingViewmodel>(context, listen: false)
        .city!;
    
    if(_seciliKategori == PostCategoryEnum.anket.index){
          for (var controller in _anketControllers) {
      _surveyItems.add(SurveyItems(
        id: 0,
        voteCount: 0,
        content: controller.text));
    }
    }

    var postModel = PostModel(
        id: 0,
        postContent: content,
        postContentTitle: contentTitle,
        userId: userId,
        illerEnum: TurkeyProvince.getByCityName(cityName).plateCode,
        postCategoryEnum: _seciliKategori,
        surveyItems: _surveyItems,

        );

    if (!mounted) return;
    var response =
        await context.read<PostSharingViewmodel>().AddPost(postModel.toJson());
    if (response.statusCode == 200) {
      if (!mounted) return;
      Navigator.pop(context);
    } 
    _formKey.currentState?.save();
  }

  void _anketEkle() {
    setState(() {
      _anketControllers.add(TextEditingController());
    });
  }

  void _anketSil(int index) {
    if (_anketControllers.length > 1) {
      setState(() {
        _anketControllers.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar22(
        right: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                
                CategoryDropDown(seciliKategori: _seciliKategori, onChanged: (value) {
                  setState(() => _seciliKategori = value);
                },),
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
                if (_seciliKategori == PostCategoryEnum.anket.index) ...[
                  const SizedBox(height: 20),
                  const Text('Anket Seçenekleri',
                      style: TextStyle(fontSize: 16)),
                  ..._anketControllers.asMap().entries.map((entry) {
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
                            onPressed: () => _anketSil(index),
                          ),
                        ],
                      ),
                    );
                  }),
                  Center(
                    child: OutlinedButton(
                      style: const ButtonStyle(),
                      onPressed: _anketEkle,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.0),
                        child: Text('Seçenek Ekle'),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: CustomAppButton(
                      btnWidth: MediaQuery.sizeOf(context).width / 4,
                      onPressed: () {
                        _submit();
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

