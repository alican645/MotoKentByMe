import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moto_kent/app/app_theme.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/local_storage.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/user_model.dart';
import 'package:moto_kent/pages/ProfileModule/EditProfilePage/edit_profile_view.dart';
import 'package:moto_kent/pages/ProfileModule/EditProfilePage/edit_profile_viewmodel.dart';
import 'package:moto_kent/pages/ProfileModule/ProfilePage/profile_viewmodel.dart';
import 'package:provider/provider.dart';

mixin EditProfileViewMixin on State<EditProfileView> {
  final TextEditingController _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;

  final TextEditingController _bioController = TextEditingController();
  TextEditingController get bioController => _bioController;

  UserModel2? userModel;

  Future<void> initialize(BuildContext context) async {
    await context.read<EditProfileViewmodel>().fetchData();
    if (!mounted) return;
    userModel =
        Provider.of<EditProfileViewmodel>(context, listen: false).userModel;
    _nameController.text = userModel!.fullName!;
    _bioController.text = userModel!.bio ?? "";

    setState(() {});
  }

  File? selectedImage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // File oluşturup, direkt _cropImage metoduna gönderiyoruz
      await cropImage(File(pickedFile.path));
    }
  }

  Future<void> cropImage(File imageFile) async {
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
        selectedImage = File(croppedFile.path);
      });
    }
  }

  Future<bool> updateProfile(
      String fullName, String bio, File? profilePhotoPath) async {
    LocalStorage localStorage = LocalStorageImpl();
    String? token = await localStorage.getValue<String>('jwt_token');
    String? userId = await localStorage.getValue<String>('user_id');

    if (token == null) {
      Fluttertoast.showToast(msg: 'Oturum açılmadı');
      return false;
    }

    try {
      Map<String, dynamic> object = {
        "userId": userId.toString(),
        "fullName": fullName,
        "bio": bio,
        "profilePicture": profilePhotoPath != null
            ? await MultipartFile.fromFile(
                profilePhotoPath.path,
                filename: profilePhotoPath.path.split('/').last,
              )
            : null,
      };

      var response = await Dio().post(
        ApiConstants.updateProfileEndpoint,
        options: Options(headers: {
          "Content-Type": "multipart/form-data",
          "Authorization": "Bearer $token"
        }),
        data: FormData.fromMap(object),
      );

      if (response.statusCode == 200) {
        if (profilePhotoPath != null) {
          var profilePhotoPathh = response.data["profilePath"];
          var fullName = response.data["fullName"];

          // Yeni dosyanın yolunu shared preferences'a kaydet
          await localStorage.setValue<String>("userfoto", profilePhotoPathh);
          await localStorage.setValue<String>("userfullname", fullName);
        }

        Fluttertoast.showToast(msg: 'Profil güncellendi');
        context.pop();
        await context.read<ProfileViewmodel>().fetchUserProfile(userId!);
      } else {
        Fluttertoast.showToast(msg: 'Bu email başka bir kullanıcıya ait');
      }

      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Bu email başka bir kullanıcıya ait');
      return false;
    }
  }
}
