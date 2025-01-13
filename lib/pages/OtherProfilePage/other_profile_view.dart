
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/components/custom_app_bar.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/MediaQueryHelper.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/pages/OtherProfilePage/other_profile_viewmodel.dart';
import 'package:provider/provider.dart';

class OtherProfileView extends StatefulWidget {
  final String? userID;
  const OtherProfileView({super.key, this.userID});

  @override
  State<OtherProfileView> createState() => _OtherProfileViewState();
}

class _OtherProfileViewState extends State<OtherProfileView> {

  Future<void> fetchUserPhotos() async {
    await context.read<OtherProfileViewmodel>().fetchUserPhoto3(widget.userID!);
  }



  Future<void> followOrUnfollowUser(BuildContext context,isFollow) async {
    String? userId=await SharedPreferencesHelper().getValue<String>("user_id");
    var respnse = await context.read<OtherProfileViewmodel>().followOrUnfollowUser(
        {
          "followerId": userId,
          "followedUserId": widget.userID
        },isFollow);

    if(respnse.statusCode==200){
      await fetchUserProfile();
      await followerRelationshipEndPoint(context);
    }
  }



  Future<void> followerRelationshipEndPoint(BuildContext context) async {
    String? userId=await SharedPreferencesHelper().getValue<String>("user_id");
    await context.read<OtherProfileViewmodel>().followerRelationshipEndPoint({
      "followerId": userId,
      "followedUserId": widget.userID
    });
  }

  Future<void> fetchUserProfile() async {
    await context.read<OtherProfileViewmodel>().fetchUserProfile(widget.userID!);
  }

  void initialize() async {
    await followerRelationshipEndPoint(context);
    await fetchUserProfile();
    await fetchUserPhotos();
  }



 @override
 void initState(){
    super.initState();
    initialize();
 }



  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Consumer<OtherProfileViewmodel>(
        builder: (context, value, child) {
          if (value.userModel == null || value.userPhotosModel==null) {
            return const CustomLoadingWidget();
          }else{
            return RefreshIndicator(
              onRefresh: () async {

              },
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
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          value.userModel!.followerCount
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text('Takipçi'),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          value.userModel!.followingCount!
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text('Takip'),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                value.isFollow?
                                OtherProfileViewRouteButton(
                                  onPressed: () async {
                                    await followOrUnfollowUser(context,false);
                                  },
                                  content: "Takipten Çık",
                                )
                                    :
                                OtherProfileViewRouteButton(
                                  onPressed: () async {
                                    //await followUser(context);
                                    await followOrUnfollowUser(context,true);
                                  },
                                  content: "Takip Et",
                                ),
                                const SizedBox(height: 10,),

                              ],
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
                          itemCount: value.userPhotosModel?.photoPaths?.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
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
                              child: Image.network(
                                '${ApiConstants.baseUrl}${value.userPhotosModel!.photoPaths![index]}',
                                fit: BoxFit.fitHeight,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }


        },
      ),
    );
  }
}

class OtherProfileViewRouteButton extends StatelessWidget {
  final String content;
  final VoidCallback onPressed;
  const OtherProfileViewRouteButton(
      {super.key, required this.content, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
          width: MediaQueryHelper.height(150),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(45),
              color: AppTheme.themeData.primaryColor),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text(content,style: const TextStyle(
                      color: Colors.white
                    ),)
                  ],),
                ),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45),
                        color: Colors.white),
                    child: const Icon(Icons.chevron_right))
              ],
            ),
          ),
        ));
  }
}
