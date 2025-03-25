import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/pages/ProfileModule/EditProfilePage/edit_profile_view_mixin.dart';
import 'package:moto_kent/pages/ProfileModule/EditProfilePage/edit_profile_viewmodel.dart';
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
  Widget buildProfilePhoto(String path) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
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

  Widget buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {
          updateProfile(
            nameController.text,
            bioController.text,
            selectedImage, // selectedImage doğru şekilde gönderiliyor
          );
        },
        child:
            const Text('Değişiklikleri Kaydet', style: TextStyle(fontSize: 16)),
      ),
    );
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
                      buildProfilePhoto(value.userModel!.profilePhotoPath!),
                      IconButton(
                          onPressed: () {
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(title: "title"),));
                            pickImage();
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
                  buildSaveButton(),
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
