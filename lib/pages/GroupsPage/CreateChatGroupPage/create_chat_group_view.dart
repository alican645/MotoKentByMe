import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/components/custom_app_button.dart';
import 'package:moto_kent/components/custom_textfield.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/models/chat_group_model.dart';
import 'package:moto_kent/pages/GroupsPage/CreateChatGroupPage/create_group_viewmodel.dart';
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

  String groupLogoPath = "";
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
      String? userId =
          await SharedPreferencesHelper().getValue<String>("user_id");
      var chatGroupModel = ChatGroupModel();
      chatGroupModel.name = _nameController.text;
      chatGroupModel.groupDescription = _descriptionController.text;
      chatGroupModel.maxMemberCount = int.tryParse(_memberCountController.text);
      chatGroupModel.groupAdminUserId = userId;
      chatGroupModel.groupIconPath = groupLogoPath;

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

    return Scaffold(
      appBar: AppBar(
        title:const Text("Grup Oluştur"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 2,
                child: Consumer<CreateChatGroupViewmodel>(
                  builder: (BuildContext context, CreateChatGroupViewmodel vm,
                      Widget? child) {
                    return DropdownButtonFormField2<String>(
                      isExpanded: true,
                      alignment: Alignment.center,
                      hint: const Text(
                        "Kategori Seçiniz",
                        style: TextStyle(color: Colors.black),
                      ),
                      value: selectedPostKategori, // Tür PostCategoryModel
                      items: vm.postCategoryModelList.map(
                        (e) {
                          return DropdownMenuItem<String>(
                            onTap: () {
                              selectedPostKategoriId = e.id!;
                              groupLogoPath = e.photoPath!;
                            },
                            value: e.categoryName, // Tür PostCategoryModel
                            child: Text(e.categoryName ?? ''),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          selectedPostKategori = value;
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Lütfen bir kategori seçiniz';
                        }
                        return null;
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.center,
                child: CustomAppButton(
                  btnWidth: 150,
                  btnText: "Grup Oluştur",
                  onPressed: () async {
                    await createChatGroup();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
