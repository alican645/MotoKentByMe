import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/local_storage.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/user_model.dart';
import 'package:moto_kent/pages/ProfileModule/EditProfilePage/edit_profile_viewmodel.dart';
import 'package:moto_kent/pages/ProfileModule/ProfilePage/profile_viewmodel.dart';
import 'package:provider/provider.dart';

class EditProfileView extends StatefulWidget {
  final List<String>? payload;
  const EditProfileView({super.key, this.payload});

  @override
  EditProfileViewState createState() => EditProfileViewState();
}

mixin EditProfileViewMixin on State<EditProfileView> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _bioController = TextEditingController();


  File? _selectedImage;

  final bool _isLoading = false;

  UserModel2? userModel;

  Future<void> initialize(BuildContext context) async {
    await context.read<EditProfileViewmodel>().fetchData();
    if (!mounted) return;
    userModel =
        Provider.of<EditProfileViewmodel>(context, listen: false).userModel;
    _nameController.text = userModel!.fullName!;
    _bioController.text = userModel!.bio??"";

    setState(() {});
  }
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
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
          builder: (context, value, child)   {
            if(value.isLoading==false){
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
                        onPressed: _pickImage,
                        icon: const Icon(Icons.camera_alt))
                  ],
                ),
                const SizedBox(height: 30),
                EditProfileTextField(
                  controller: _nameController,
                  labelText: "Kullanıcı Adı",
                  prefixIconData: Icons.person,
                  validationText: "",
                  maxLines: 1,
                ),
                const SizedBox(height: 20),
                EditProfileTextField(
                  controller: _bioController,
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

  Widget _buildProfilePhoto(String path) {
    return SizedBox(
      height: 150,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: _selectedImage != null
            ? Image.file(_selectedImage!, fit: BoxFit.cover)
            : Image.network(
            "${ApiConstants.baseUrl}/$path",
                fit: BoxFit.cover,
                // Hata durumu
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
              _nameController.text, _bioController.text, _selectedImage);
        },
        child:
            const Text('Değişiklikleri Kaydet', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
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
