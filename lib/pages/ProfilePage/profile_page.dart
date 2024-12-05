import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moto_kent/models/user_model.dart';
import 'package:moto_kent/pages/ProfilePage/profile_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moto_kent/constants/api_constants.dart'; // API endpointleri import edildi.

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? _userModel;
  final Color _editProfileButtonBackground = const Color(0xfff48a34);
  final imagePicker = ImagePicker();

  File? _selectedProfilePhoto;
  bool isLongPress = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        fetchUserProfile();
        fetchUserPhotos();
      },
    );
  }

  Future<void> fetchUserPhotos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    if (!mounted) return;
    await context.read<ProfileViewmodel>().fetchUserPhoto3(userId!);
  }

  Future<void> fetchUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    if (!mounted) return;
    await context.read<ProfileViewmodel>().fetchUserProfile(userId!);
  }

  Future<void> uploadPhoto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      if (!mounted) return;
      await context.read<ProfileViewmodel>().uploadPhoto(userId!, pickedImage);
    }
  }



  Future<bool> updateProfile2(String fullName, String bio, File? profilePhotoPath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');
    String? userId = prefs.getString('user_id');

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
        await fetchUserProfile(); // Profil güncellendikten sonra yeniden yükle
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

    return Consumer<ProfileViewmodel>(
      builder: (context, value, child) {
        if (value.userPhotosModel == null || value.userModel == null) {
          return const Center(child: CircularProgressIndicator());
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
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: value.userModel!.profilePhotoPath !=
                                    null &&
                                value.userModel!.profilePhotoPath!.isNotEmpty
                            ? NetworkImage(
                                '${ApiConstants.baseUrl}${value.userModel!.profilePhotoPath!}')
                            : const AssetImage(
                                    'assets/images/default_profile.png')
                                as ImageProvider,
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
        return Padding(
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
              const SizedBox(height: 8),
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
            ],
          ),
        );
      },
    );
  }
}
