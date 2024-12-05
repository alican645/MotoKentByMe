import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moto_kent/components/custom_app_button.dart';
import 'package:moto_kent/components/custom_textfield.dart';
import 'package:moto_kent/models/chat_group_model.dart';
import 'package:moto_kent/pages/GroupsPage/CreateChatGroupPage/create_group_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateChatGroupView extends StatefulWidget {
  CreateChatGroupView({super.key});

  @override
  State<CreateChatGroupView> createState() => _CreateChatGroupViewState();
}

class _CreateChatGroupViewState extends State<CreateChatGroupView> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _memberCountController = TextEditingController();

  String groupLogoPath = "";

  @override
  Widget build(BuildContext context) {
    context.read<CreateChatGroupViewmodel>().fetchPostCategoryList2();

    Future<void> createChatGroup() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString("user_id");
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
          showDialog(context: context, builder: (context) => AlertDialog(
            title: Text("Grup oluşturuldu.."),
          ),);
          Navigator.pop(context);
        }
      } catch (e) {}
    }

    int selectedPostKategoriId = 0;
    String selectedPostKategori = "Patiler";
    return Scaffold(
      body: Column(
        children: [
          CustomTextField(
              controller: _nameController, labelText: "Grup Adını Giriniz"),
          CustomTextField(
              controller: _descriptionController,
              labelText: "Grup Açıklamasını Giriniz"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: 200,
                  child: CustomTextField(
                      controller: _memberCountController,
                      labelText: "Maks Üye Sayısı")),
              SizedBox(
                width: 200,
                child: Consumer<CreateChatGroupViewmodel>(
                  builder: (BuildContext context, CreateChatGroupViewmodel vm,
                      Widget? child) {
                    return DropdownButtonFormField2<String>(
                      isExpanded: true,
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        labelText: 'Select Category',
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          CustomAppButton(
            btnWidth: 150,
            btnText: "Grup Oluştur",
            onPressed: () async {
              await createChatGroup();
              print("object");
            },
          )
        ],
      ),
    );
  }
}
