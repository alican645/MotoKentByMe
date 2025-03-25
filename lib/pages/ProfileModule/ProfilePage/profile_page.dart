import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moto_kent/app/app_theme.dart';
import 'package:moto_kent/components/custom_app_bar_widget.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/pages/ProfileModule/ProfilePage/profile_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:moto_kent/constants/api_constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final imagePicker = ImagePicker();
  File? selectedImage;
  bool isLongPress = false;
  String? userID;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        userID = await LocalStorageImpl().getValue<String>("user_id");
        await context.read<ProfileViewmodel>().fetchUserProfile(userID!);
      },
    );
  }

  Future<File?> _cropImage(File imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: AppTheme.themeData.primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
        ),
      ],
    );
    if (croppedFile != null) {
      return File(croppedFile.path);
    }
    return null;
  }

  Future<void> uploadPhoto() async {
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      File? croppedImage = await _cropImage(File(pickedImage.path));
      if (croppedImage != null) {
        if (!mounted) return;
        var response = await context
            .read<ProfileViewmodel>()
            .uploadPhoto(userID!, XFile(croppedImage.path));
        if (response.statusCode == 200 || response.statusCode == 201) {
          userID = await LocalStorageImpl().getValue<String>("user_id");
          await context.read<ProfileViewmodel>().fetchUserProfile(userID!);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar22(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context
                  .go("${AppRoutes.profilePage}/${AppRoutes.myAppSettingPage}");
            },
          )
        ],
      ),
      body: Consumer<ProfileViewmodel>(
        builder: (context, value, child) {
          if (value.userModel == null) {
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
                        Flexible(
                          child: InkWell(
                            onTap: () {
                              context.push(
                                  "${AppRoutes.profilePage}/${AppRoutes.followedPage}");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FollowedFollowerCountWidget(
                                  content: "Takipçi",
                                  count:
                                      value.userModel!.followerCount.toString(),
                                ),
                                SizedBox(width: width * 0.05),
                                FollowedFollowerCountWidget(
                                  content: "Takip",
                                  count: value.userModel!.followingCount
                                      .toString(),
                                ),
                              ],
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
                      child: Text(value.userModel!.bio ?? ''),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        context.go(
                            "${AppRoutes.profilePage}/${AppRoutes.myAppSettingPage}/${AppRoutes.editProfilePage}");
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 1),
                        decoration: BoxDecoration(
                            color: const Color(0xfff48a34),
                            borderRadius: BorderRadius.circular(16)),
                        child: const Text(
                          "Profili Düzenle",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                      indent: 20,
                      endIndent: 20,
                    ),
                    // Fotoğraf Galerisi Kısmı
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                        itemCount: value.userModel!.photos!.length + 1,
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
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return Dialog(
                                      backgroundColor: Colors.transparent,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Image.network(
                                              '${ApiConstants.baseUrl}${value.userModel!.photos![index - 1]}')),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)),
                                child: Image.network(
                                  '${ApiConstants.baseUrl}${value.userModel!.photos![index - 1]}',
                                  fit: BoxFit.fitHeight,
                                ),
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
}

class FollowedFollowerCountWidget extends StatelessWidget {
  const FollowedFollowerCountWidget({
    super.key,
    required this.content,
    required this.count,
  });

  final String content;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(content),
      ],
    );
  }
}
