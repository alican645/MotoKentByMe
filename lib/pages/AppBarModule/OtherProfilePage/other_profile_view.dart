import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/custom_app_bar.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/components/fallow_button.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/user_rating_model.dart';
import 'package:moto_kent/pages/AppBarModule/OtherProfilePage/other_profile_viewmodel.dart';
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

  Future<void> followOrUnfollowUser(isFollow) async {
    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    if (!mounted) return;
    var respnse = await context
        .read<OtherProfileViewmodel>()
        .followOrUnfollowUser(
            {"followerId": userId, "followedUserId": widget.userID}, isFollow);

    if (respnse.statusCode == 200) {
      await fetchUserProfile();
      if (!mounted) return;
      await followerRelationshipEndPoint(context);
    }
  }

  Future<void> followerRelationshipEndPoint(BuildContext context) async {
    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    await context.read<OtherProfileViewmodel>().followerRelationshipEndPoint(
        {"followerId": userId, "followedUserId": widget.userID});
  }

  Future<void> fetchUserProfile() async {
    await context
        .read<OtherProfileViewmodel>()
        .fetchUserProfile(widget.userID!);
  }

  void initialize() async {
    await fetchUserProfile();
    await followerRelationshipEndPoint(context);
    await fetchUserPhotos();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        initialize();
      },
    );
    super.initState();
  }

  Future<void> startConversation() async {
    var response = await context
        .read<OtherProfileViewmodel>()
        .startPrivateConversation(widget.userID!);
    if (response.statusCode == 200) {
      final Map<String, dynamic> args = {
        "userId": widget.userID,
        "connectionId": response.data["connectionId"],
        "privateConversationId": response.data["privateConversationId"]
      };
      if (!mounted) return;
      context.push(
          '${AppRoutes.explorePage}/${AppRoutes.searchPage}/${AppRoutes.otherUserProfile}/${AppRoutes.privateChatPage}',
          extra: args);
    }
  }

// AlertDialog gösteren onRatingConfirm fonksiyonu
  Future<bool> showRatingConfirmDialog(int rating) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Onay"),
              content: Text(
                  "Bu kullanıcıyı $rating ile oylamak istediğinize emin misiniz?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Hayır"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Evet"),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(),
      body: Consumer<OtherProfileViewmodel>(
        builder: (context, value, child) {
          if (value.userModel == null || value.userPhotosModel == null) {
            return const CustomLoadingWidget();
          } else {
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
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(16)),
                                height: 130,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                      '${ApiConstants.baseUrl}/${value.userModel!.profilePhotoPath!}'),
                                ),
                              ),
                              StaticRatingWidget(
                                  rating: value.userModel!.totalRating!),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text(
                                          "Oylama işlemi sadece bir kere yapılır."),
                                      content: SingleChildScrollView(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            RatingWidget(
                                              onRatingConfirm: (p1) async {
                                                return await _rateThisUser(
                                                    value.isFirstRate,
                                                    p1,
                                                    context);
                                              },
                                              initialRating:
                                                  value.userModel!.rating!,
                                              maxRating: 5,
                                              activeColor: Colors.yellow,
                                              inactiveColor: Colors.grey,
                                              iconSize: 25,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Kullanıcıyı Oyla",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            ],
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
                                const SizedBox(
                                  height: 10,
                                ),
                                PostDetailPageButton(
                                  onPressed: () {
                                    startConversation();
                                  },
                                  content: "Mesaj At",
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                value.isFollow
                                    ? PostDetailPageButton(
                                        onPressed: () async {
                                          await followOrUnfollowUser(false);
                                        },
                                        content: "Takipten Çık",
                                      )
                                    : PostDetailPageButton(
                                        onPressed: () async {
                                          //await followUser(context);
                                          await followOrUnfollowUser(true);
                                        },
                                        content: "Takip Et",
                                      ),
                                const SizedBox(
                                  height: 10,
                                ),
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
                        child: Text(value.userModel!.bio ??
                            'Biyografi henüz eklenmedi'),
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
                                          borderRadius:
                                              BorderRadius.circular(16),
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

  Future<bool> _rateThisUser(
      bool firstRate, int p1, BuildContext context) async {
    if (firstRate) {
      var value = await showRatingConfirmDialog(p1);
      if (value) {
        var object = UserRatingModel(targetUserId: widget.userID, rating: p1);
        var response =
            await context.read<OtherProfileViewmodel>().rateThisUser(object);
        if (response == true) {
          return value;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Kullanıcı oylama işlemi tamamlanamadı.")));
          return false;
        }
      } else {
        return value;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Kullanıcı oylama işlemi sadece bir kere yapılır.")));
      throw Exception("");
    }
  }
}

/// RatingWidget artık onRatingConfirm parametresini alıyor.
class RatingWidget extends StatefulWidget {
  const RatingWidget({
    super.key,
    required this.initialRating,
    required this.onRatingConfirm,
    this.maxRating = 5,
    this.iconSize = 25.0,
    this.activeColor = Colors.yellow,
    this.inactiveColor = Colors.grey,
  });

  final int initialRating;
  final int maxRating;
  final double iconSize;
  final Color activeColor;
  final Color inactiveColor;

  /// Rating seçildiğinde, dialog gösterilmesi için çağrılan fonksiyon.
  /// Bu fonksiyon, BuildContext ve seçilen rating değerini alıp,
  /// kullanıcının onayını (true/false) döndürmelidir.
  final Future<bool> Function(int) onRatingConfirm;

  @override
  State<RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  late int currentRating;

  @override
  void initState() {
    super.initState();
    currentRating = widget.initialRating;
  }

  Future<void> _updateRating(int newRating) async {
    // onRatingConfirm fonksiyonu çağrılıyor.
    final bool confirmed = await widget.onRatingConfirm(newRating);
    if (confirmed) {
      setState(() {
        currentRating = newRating;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(widget.maxRating, (index) {
        final starValue = index + 1;
        return RatingButton(
          value: starValue,
          ratingValue: currentRating,
          iconSize: widget.iconSize,
          activeColor: widget.activeColor,
          inactiveColor: widget.inactiveColor,
          onTap: () => _updateRating(starValue),
        );
      }),
    );
  }
}

class RatingButton extends StatelessWidget {
  const RatingButton({
    super.key,
    required this.value,
    required this.ratingValue,
    required this.onTap,
    required this.iconSize,
    required this.activeColor,
    required this.inactiveColor,
  });

  final int value;
  final int ratingValue;
  final VoidCallback onTap;
  final double iconSize;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(
        Icons.star,
        size: iconSize,
        color: value <= ratingValue ? activeColor : inactiveColor,
      ),
    );
  }
}

class StaticRatingWidget extends StatelessWidget {
  const StaticRatingWidget({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.iconSize = 25.0,
    this.activeColor = Colors.yellow,
    this.inactiveColor = Colors.grey,
  });

  final double rating;
  final int maxRating;
  final double iconSize;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    // rating değerini en yakın tam sayıya yuvarla
    final int activeStars = rating.round();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(maxRating, (index) {
          return Icon(
            Icons.star,
            size: iconSize,
            color: index < activeStars ? activeColor : inactiveColor,
          );
        }),
        Text(
          "(${rating.toStringAsFixed(2)})",
          style: const TextStyle(color: Colors.grey),
        )
      ],
    );
  }
}
