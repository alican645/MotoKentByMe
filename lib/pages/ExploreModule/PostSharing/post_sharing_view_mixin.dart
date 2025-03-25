import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moto_kent/app/app_theme.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/constants/enums.dart';
import 'package:moto_kent/init/Helpers/local_storage.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/post_model.dart';
import 'package:moto_kent/pages/ExploreModule/PostSharing/post_sharing_view.dart';
import 'package:moto_kent/pages/ExploreModule/PostSharing/post_sharing_viewmodel.dart';
import 'package:moto_kent/pages/ProfileModule/ProfilePage/profile_viewmodel.dart';
import 'package:provider/provider.dart';

mixin PostSharingViewMixin on State<PostSharingView> {
  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get fromKey => _formKey;
  final paylasBtnTxt = "Paylaş";

  int? seciliKategori;

  List<TextEditingController> anketControllers = [TextEditingController()];
  List<File> selectedImages = [];

  List<SurveyItems> surveyItems = [];
  List<Object> photos = [];
  String? selectedPostKategori;

  TextEditingController contentController = TextEditingController();
  TextEditingController contentTitleContreller = TextEditingController();

  Future<void> submit() async {
    LocalStorage localStorage = LocalStorageImpl();
    String? token = await localStorage.getValue<String>('jwt_token');
    String? userId = await localStorage.getValue<String>('user_id');

    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }

    String content = contentController.text;
    String contentTitle = contentTitleContreller.text;
    if (!mounted) return;
    String cityName =
        Provider.of<PostSharingViewmodel>(context, listen: false).city!;

    if (seciliKategori == PostCategoryEnum.anket.index) {
      for (var controller in anketControllers) {
        surveyItems
            .add(SurveyItems(id: 0, voteCount: 0, content: controller.text));
      }
    }
    if (seciliKategori == PostCategoryEnum.ilan.index) {
      for (var image in selectedImages) {
        photos.add(await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ));
      }
    }

    var postModel = PostModel(
        id: 0,
        postContent: content,
        postContentTitle: contentTitle,
        userId: userId,
        illerEnum: TurkeyProvince.getByCityName(cityName).plateCode,
        postCategoryEnum: seciliKategori,
        surveyItems: surveyItems,
        postIlanPhotos: photos);

    var response = await Dio().post(
      ApiConstants.addPost,
      options: Options(headers: {
        "Content-Type":
            "multipart/form-data", // Multipart içerik tipi ayarlandı
        "Authorization": "Bearer $token"
      }),
      data: FormData.fromMap(
          postModel.toJson()), // FormData ile veriler gönderiliyor
    );

    if (response.statusCode == 200) {
      context.pop();
      await context.read<ProfileViewmodel>().fetchUserProfile(
          userId!); // Profil güncellendikten sonra yeniden yükle
    } else {}

    return;
  }

  void anketEkle() {
    setState(() {
      anketControllers.add(TextEditingController());
    });
  }

  void resimEkle(File file) {
    setState(() {
      selectedImages.add(file);
    });
  }

  void anketSil(int index) {
    if (anketControllers.length > 1) {
      setState(() {
        anketControllers.removeAt(index);
      });
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // File oluşturup, direkt _cropImage metoduna gönderiyoruz
      await _cropImage(File(pickedFile.path));
    }
  }

  Future<void> _cropImage(File imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: AppTheme.themeData.primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
        ),
      ],
    );
    if (croppedFile != null) {
      setState(() {
        // Doğrudan instance alanını güncelliyoruz
        File selectedImage = File(croppedFile.path);
        resimEkle(selectedImage);
      });
    }
  }
}
