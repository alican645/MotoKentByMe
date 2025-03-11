import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moto_kent/components/custom_app_bar.dart';
import 'package:moto_kent/components/custom_app_button.dart';
import 'package:moto_kent/components/custom_textfield.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/local_storage.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/chat_group_model.dart';
import 'package:moto_kent/pages/GroupChatModule/CreateChatGroupPage/create_group_viewmodel.dart';
import 'package:moto_kent/pages/ProfileModule/ProfilePage/profile_viewmodel.dart';
import 'package:provider/provider.dart';

class CreateChatGroupView extends StatefulWidget {
  CreateChatGroupView({super.key});

  @override
  State<CreateChatGroupView> createState() => _CreateChatGroupViewState();
}

class _CreateChatGroupViewState extends State<CreateChatGroupView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _memberCountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage ;

  int? selectedPostKategoriId;
  String? selectedPostKategori;
  @override
  Widget build(BuildContext context) {
    context.read<CreateChatGroupViewmodel>().fetchPostCategoryList2();

    Future<void> createChatGroup() async {
      final isValid = _formKey.currentState?.validate();
      if (!isValid!) {
        return;
      }
      String? userId = await LocalStorageImpl().getValue<String>("user_id");
      var chatGroupModel = ChatGroupModel();
      chatGroupModel.name = _nameController.text;
      chatGroupModel.groupDescription = _descriptionController.text;
      chatGroupModel.maxMemberCount = int.tryParse(_memberCountController.text);
      chatGroupModel.groupAdminUserId = userId;

      try {
        var response = await context
            .read<CreateChatGroupViewmodel>()
            .createChatGroup(chatGroupModel.toJson());
        if (response.statusCode == 200) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Grup oluşturuldu.."),
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {}
      _formKey.currentState?.save();
    }

    Future<bool> _updateProfile(File? profilePhotoPath) async {
      LocalStorage localStorage = LocalStorageImpl();
      String? token = await localStorage.getValue<String>('jwt_token');
      String? userId = await localStorage.getValue<String>('user_id');

      if (token == null) {
        Fluttertoast.showToast(msg: 'Oturum açılmadı');
        return false;
      }

      try {
              var chatGroupModel = ChatGroupModel();
              chatGroupModel.name = _nameController.text;
              chatGroupModel.groupDescription = _descriptionController.text;
              chatGroupModel.maxMemberCount = int.tryParse(_memberCountController.text);
              chatGroupModel.groupAdminUserId = userId;
              chatGroupModel.groupImage =profilePhotoPath != null
              ? await MultipartFile.fromFile(
                  profilePhotoPath.path,
                  filename: profilePhotoPath.path.split('/').last,
                )
              : null;

        var response = await Dio().post(
          ApiConstants.createChatGroup,
          options: Options(headers: {
            "Content-Type":
                "multipart/form-data", // Multipart içerik tipi ayarlandı
            "Authorization": "Bearer $token"
          }),
          data: FormData.fromMap(chatGroupModel.toJson()), // FormData ile veriler gönderiliyor
        );

        if (response.statusCode == 200) {

          context.pop();
          
        } else {
          Fluttertoast.showToast(msg: 'Grup oluşturulamadı');
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

    return Scaffold(
      appBar: CustomAppBar(
        title: "Grup Oluştur",
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfilePhoto(() => _pickImage(),),
              CustomTextField(
                controller: _nameController,
                hintText: "Grup Adını Giriniz",
                maxLength: 100,
                validationText: "Grup adı boş bırakılamaz",
              ),
              CustomTextField(
                controller: _descriptionController,
                hintText: "Grup Açıklamasını Giriniz",
                validationText: "Grup açıklaması boş bırakılamaz",
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 2,
                child: CustomTextField(
                  controller: _memberCountController,
                  hintText: "Maks Üye Sayısı",
                  validationText: "Maksimum üye sayısı boş bırakılamaz",
                ),
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.center,
                child: CustomAppButton(
                  btnWidth: 150,
                  btnText: "Grup Oluştur",
                  onPressed: () async {
                    await _updateProfile(_selectedImage);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePhoto(VoidCallback onPressed)  {
    return Center(
      child: SizedBox(
        height: 150,
        width: 150,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _selectedImage != null
                  ? FileImage(_selectedImage!)
                  : const AssetImage("assets/images/groupChatImage.png"),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: onPressed,
              ),
            )
          ],
        ),
      ),
    );
  }
}
