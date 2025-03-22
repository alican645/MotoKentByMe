import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/local_storage.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/chat_group_model.dart';
import 'package:moto_kent/pages/GroupChatModule/CreateChatGroupPage/create_chat_group_view.dart';
import 'package:moto_kent/pages/GroupChatModule/CreateChatGroupPage/create_group_viewmodel.dart';
import 'package:provider/provider.dart';

mixin CreateChatGroupViewMixin on State<CreateChatGroupView> {
  final TextEditingController _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;
  final TextEditingController _descriptionController = TextEditingController();
  TextEditingController get descriptionController => _descriptionController;
  final TextEditingController _memberCountController = TextEditingController();
  TextEditingController get memberCountController => _memberCountController;
  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;
  File? get selectedImage => _selectedImage;
  File? _selectedImage;

  int? _selectedPostKategoriId;
  int? get selectedPostKategoriId => _selectedPostKategoriId;
  String? _selectedPostKategori;
  String? get selectedPostKategori => _selectedPostKategori;

  void showDialogMessage(String message);

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
        showDialogMessage("Grup oluşturuldu..");
        if (!mounted) return;
        Navigator.pop(context);
      }
    } catch (e) {}
    _formKey.currentState?.save();
  }

  Future<bool> updateProfile(File? profilePhotoPath) async {
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
      chatGroupModel.groupImage = profilePhotoPath != null
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
        data: FormData.fromMap(
            chatGroupModel.toJson()), // FormData ile veriler gönderiliyor
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

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }
}
