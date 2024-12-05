import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/components/custom_app_button.dart';
import 'package:moto_kent/models/post_model.dart';
import 'package:moto_kent/pages/ExplorePage/explore_viewmodel.dart';
import 'package:moto_kent/pages/PostSharing/post_sharing_viewmodel.dart';
import 'package:moto_kent/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



class PostSharingView extends StatefulWidget {
  const PostSharingView({super.key});

  @override
  State<PostSharingView> createState() => _PostSharingViewState();
}

class _PostSharingViewState extends State<PostSharingView> {
  final imagePicker = ImagePicker();

  final paylasBtnTxt="Paylaş";
  String selectedPostKategori = "Patiler";
  int selectedPostKategoriId = 0;
  TextEditingController contentController= TextEditingController();
  TextEditingController contentTitleContreller= TextEditingController();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<PostSharingViewmodel>().fetchPostCategoryList2();
      },
    );
  }

  void dispose(){
    super.dispose();
    contentTitleContreller.dispose();
    contentController.dispose();
  }

  Future<void> _submit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId=await prefs.getString("user_id");
    String content = contentController.text;
    String contentTitle = contentTitleContreller.text;
    var postModel = PostModel(
      id: 0,
      postCategoryId:selectedPostKategoriId,
      postContent: content,
      postContentTitle: contentTitle,
      postDate: DateTime.now(),
      postLocation: "Ankara",
      userId:userId,
    );

      if(!mounted) return;
      var response=await context.read<PostSharingViewmodel>().AddPost(postModel.toJson());
      if(response.statusCode==200){
        if(!mounted) return;
        Navigator.pop(context);

      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Utils.formatDateToDayMonthYear(DateTime.now()),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Row(
                    children: [
                      Text(
                        "Ankara",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.location_on_outlined)
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: contentTitleContreller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Enter your comment title..",
                ),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: contentController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Enter your comment...",
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 200,
                  child: Consumer<PostSharingViewmodel>(
                    builder: (BuildContext context, PostSharingViewmodel vm,
                        Widget? child) {
                      return DropdownButtonFormField2<String>(
                        isExpanded: true,
                        value: selectedPostKategori, // Tür PostCategoryModel
                        items: vm.postCategoryModelList.map(
                          (e) {
                            return DropdownMenuItem<String>(
                              onTap: () {
                                selectedPostKategoriId = e.id!;
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
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: CustomAppButton(
                  btnWidth: MediaQuery.sizeOf(context).width/4,
                    onPressed: () {
                      _submit();
                    },
                    btnText: paylasBtnTxt),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

