import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/local_storage.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/pages/ProfileModule/EditProfilePage/edit_profile_view_mixin.dart';
import 'package:moto_kent/pages/ProfileModule/EditProfilePage/edit_profile_viewmodel.dart';
import 'package:moto_kent/pages/ProfileModule/ProfilePage/profile_viewmodel.dart';
import 'package:provider/provider.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({
    super.key,
  });

  @override
  EditProfileViewState createState() => EditProfileViewState();
}

class EditProfileViewState extends State<EditProfileView>
    with EditProfileViewMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        initialize(context);
      },
    );
    super.initState();
  }

// Sınıfınızın üst kısmında, mixin veya state içinde selectedImage tanımlı olmalı:
  File? selectedImage;

  Future<void> _pickImage() async {
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
          toolbarColor: Colors.deepOrange,
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

  Widget _buildProfilePhoto(String path) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey
        )
      ),
      height: 150,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: selectedImage != null
            ? Image.file(selectedImage!, fit: BoxFit.cover)
            : Image.network(
          "${ApiConstants.baseUrl}/$path",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {
          _updateProfile(
            nameController.text,
            bioController.text,
            selectedImage, // selectedImage doğru şekilde gönderiliyor
          );
        },
        child: const Text('Değişiklikleri Kaydet', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Future<bool> _updateProfile(
      String fullName, String bio, File? profilePhotoPath) async {
    LocalStorage localStorage = LocalStorageImpl();
    String? token = await localStorage.getValue<String>('jwt_token');
    String? userId = await localStorage.getValue<String>('user_id');

    if (token == null) {
      Fluttertoast.showToast(msg: 'Oturum açılmadı');
      return false;
    }

    try {
      // Map dinamik olarak tanımlandı
      Map<String, dynamic> object = {
        "userId": userId.toString(),
        "fullName": fullName,
        //"email":email,
        "bio": bio,
        "profilePicture": profilePhotoPath != null
            ? await MultipartFile.fromFile(
                profilePhotoPath.path,
                filename: profilePhotoPath.path.split('/').last,
              )
            : null, // Profil fotoğrafı zorunlu değilse null olabilir
      };

      var response = await Dio().post(
        ApiConstants.updateProfileEndpoint,
        options: Options(headers: {
          "Content-Type":
              "multipart/form-data", // Multipart içerik tipi ayarlandı
          "Authorization": "Bearer $token"
        }),
        data: FormData.fromMap(object), // FormData ile veriler gönderiliyor
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Profil güncellendi');
        context.pop();
        await context.read<ProfileViewmodel>().fetchUserProfile(
            userId!); // Profil güncellendikten sonra yeniden yükle
      } else {
        Fluttertoast.showToast(msg: 'Bu email başka bir kullanıcıya ait');
      }

      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Bu email başka bir kullanıcıya ait');
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Profili Düzenle'),
        ),
        body: Consumer<EditProfileViewmodel>(
          builder: (context, value, child) {
            if (value.isLoading == false) {
              return const CircularProgressIndicator();
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildProfilePhoto(value.userModel!.profilePhotoPath!),
                      IconButton(
                          onPressed: () {
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(title: "title"),));
                            _pickImage();
                            },
                          icon: const Icon(Icons.camera_alt))
                    ],
                  ),
                  const SizedBox(height: 30),
                  EditProfileTextField(
                    controller: nameController,
                    labelText: "Kullanıcı Adı",
                    prefixIconData: Icons.person,
                    validationText: "",
                    maxLines: 1,
                  ),
                  const SizedBox(height: 20),
                  EditProfileTextField(
                    controller: bioController,
                    labelText: "Biyografi",
                    validationText: "",
                    maxLines: 4,
                  ),
                  const SizedBox(height: 30),
                  _buildSaveButton(),
                ],
              ),
            );
          },
        ));
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }
}

class EditProfileTextField extends StatelessWidget {
  const EditProfileTextField(
      {super.key,
      required this.controller,
      required this.labelText,
      this.prefixIconData,
      required this.validationText,
      required this.maxLines});

  final TextEditingController controller;
  final String labelText;
  final String validationText;
  final IconData? prefixIconData;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIconData == null ? null : Icon(prefixIconData),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationText;
        }
        return null;
      },
    );
  }
}



