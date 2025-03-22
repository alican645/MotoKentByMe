import 'package:flutter/material.dart';
import 'package:moto_kent/components/custom_app_bar.dart';
import 'package:moto_kent/components/custom_app_button.dart';
import 'package:moto_kent/components/custom_textfield.dart';
import 'package:moto_kent/pages/GroupChatModule/CreateChatGroupPage/create_chat_group_view_mixin.dart';
import 'package:moto_kent/pages/GroupChatModule/CreateChatGroupPage/create_group_viewmodel.dart';
import 'package:provider/provider.dart';

class CreateChatGroupView extends StatefulWidget {
  const CreateChatGroupView({super.key});

  @override
  State<CreateChatGroupView> createState() => _CreateChatGroupViewState();
}

class _CreateChatGroupViewState extends State<CreateChatGroupView>
    with CreateChatGroupViewMixin {
  @override
  Widget build(BuildContext context) {
    context.read<CreateChatGroupViewmodel>().fetchPostCategoryList2();

    return Scaffold(
      appBar: CustomAppBar(
        title: "Grup Oluştur",
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfilePhoto(
                () {
                  pickImage();
                },
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: nameController,
                hintText: "Grup Adını Giriniz",
                maxLength: 100,
                validationText: "Grup adı boş bırakılamaz",
              ),
              CustomTextField(
                controller: descriptionController,
                hintText: "Grup Açıklamasını Giriniz",
                validationText: "Grup açıklaması boş bırakılamaz",
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 2,
                child: CustomTextField(
                  controller: memberCountController,
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
                    await updateProfile(selectedImage);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePhoto(VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: SizedBox(
            height: 100,
            width: 100,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: selectedImage != null
                        ? Image.file(
                            selectedImage!,
                            scale: 5,
                          )
                        : Image.asset(
                            "assets/images/groupChatImage.png",
                            scale: 5,
                          )),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: IconButton(
              icon: const Icon(
                Icons.camera_alt,
                size: 24,
              ),
              onPressed: onPressed,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void showDialogMessage(String message) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(message),
        ),
      );
}
