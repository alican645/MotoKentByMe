import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/models/user_model.dart';
import 'package:moto_kent/pages/ProfilePage/profile_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:moto_kent/constants/api_constants.dart'; // API endpointleri import edildi.

class ProfilePage extends StatefulWidget {

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? _userModel;
  final imagePicker = ImagePicker();

  File? _selectedProfilePhoto;
  bool isLongPress = false;
  String? userID;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async{
        userID=await SharedPreferencesHelper().getValue<String>("user_id");
        await context.read<ProfileViewmodel>().initialize(userID!);
      },
    );
  }





  Future<void> uploadPhoto() async {
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      if (!mounted) return;
      await context.read<ProfileViewmodel>().uploadPhoto(userID!, pickedImage);
    }
  }



  Future<bool> updateProfile2(String fullName, String bio, File? profilePhotoPath) async {

    String? token =await SharedPreferencesHelper().getValue<String>('jwt_token');
    String? userId =await SharedPreferencesHelper().getValue<String>('user_id');

    if (token == null) {
      Fluttertoast.showToast(msg: 'Oturum açılmadı');
      return false;
    }

    try {
      // Map dinamik olarak tanımlandı
      Map<String, dynamic> object = {
        "userId": userId.toString(),
        "fullName": fullName,
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
          "Content-Type": "multipart/form-data", // Multipart içerik tipi ayarlandı
          "Authorization": "Bearer $token"
        }),
        data: FormData.fromMap(object), // FormData ile veriler gönderiliyor
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Profil güncellendi');

        await context.read<ProfileViewmodel>().initialize(userID!);; // Profil güncellendikten sonra yeniden yükle
      } else {
        Fluttertoast.showToast(msg: 'Profil güncellenemedi: ${response.statusCode}');
      }

      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Hata oluştu: $e');
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Consumer<ProfileViewmodel>(
        builder: (context, value, child) {
          if (value.userPhotosModel == null || value.userModel == null) {
            return const Center(child: CustomLoadingWidget());
          }
      
          return RefreshIndicator(
            onRefresh: () async {},
            // Sayfayı yenilemek için çağrılacak fonksiyon
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              // Scroll işlemi her durumda etkin
              child: Padding(
                padding: EdgeInsets.all(width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profil Fotoğrafı ve Kullanıcı Bilgileri
                    Row(
                      children: [
                        SizedBox(
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                                '${ApiConstants.baseUrl}/${value.userModel!.profilePhotoPath!}'),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    value.userModel!.followerCount.toString(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Text('Takipçi'),
                                ],
                              ),
                              SizedBox(width: width * 0.05),
                              Column(
                                children: [
                                  Text(
                                    value.userModel!.followingCount!.toString(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Text('Takip'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: width * 0.2,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: const Icon(Icons.settings),
                              onPressed: () {
                                _showEditProfileModal(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Kullanıcı Bilgileri
                    Row(
                      children: [
                        Text(
                          value.userModel!.fullName!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          value.userModel!.bio ?? 'Biyografi henüz eklenmedi'),
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                      thickness: 2,
                      indent: 20,
                      endIndent: 20,
                    ),
                    // Fotoğraf Galerisi Kısmı
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                        itemCount: value.userPhotosModel!.photoPaths!.length + 1,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return GestureDetector(
                              onTap: uploadPhoto,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[300],
                                ),
                                child: const Center(
                                  child: Icon(Icons.add,
                                      size: 40, color: Colors.black),
                                ),
                              ),
                            );
                          } else {
                            return GestureDetector(
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return Dialog(
                                      backgroundColor: Colors.transparent,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: Image.network(
                                              '${ApiConstants.baseUrl}${value.userPhotosModel!.photoPaths![0]}')),
                                    );
                                  },
                                );
                              },
                              onTap: () {
                                context.go("/profile_page/post_detail_view",
                                    extra:
                                        '${ApiConstants.baseUrl}${value.userPhotosModel!.photoPaths![index - 1]}');
                              },
                              child: Image.network(
                                '${ApiConstants.baseUrl}${value.userPhotosModel!.photoPaths![index - 1]}',
                                fit: BoxFit.fitHeight,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showEditProfileModal(BuildContext context) {
    TextEditingController fullNameController =
        TextEditingController(text: _userModel?.fullName);
    TextEditingController bioController =
        TextEditingController(text: _userModel?.bio);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Profili Düzenle",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: fullNameController,
                  decoration: const InputDecoration(labelText: "Ad Soyad"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: bioController,
                  decoration: const InputDecoration(labelText: "Biyografi"),
                ),
                const SizedBox(height: 8),
                Flexible(child: Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                  ElevatedButton(
                    onPressed: () async {
                      final pickedImage =
                      await imagePicker.pickImage(source: ImageSource.gallery);
                      if (pickedImage != null) {
                        setState(() {
                          _selectedProfilePhoto = File(pickedImage.path);
                        });
                      }
                    },
                    child: const Text("Profil Fotoğrafı Seç"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      bool isCompleted = await updateProfile2(
                          fullNameController.text,
                          bioController.text,
                          _selectedProfilePhoto);
                      if (isCompleted) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Kaydet"),
                  ),
                ],)),
                ElevatedButton(
                  onPressed: () async {
                    logOut(context);
                  },
                  child: const Text("Çıkış Yap"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void logOut(BuildContext context) {
    SharedPreferencesHelper().remove("username");
    SharedPreferencesHelper().remove("password");
    context.go("/login_page");
  }
}
