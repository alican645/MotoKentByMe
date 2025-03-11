import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/custom_app_bar.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/group_join_request_model.dart';
import 'package:moto_kent/models/user_model.dart';
import 'package:moto_kent/pages/GroupChatModule/JoinGroupRequestPage/join_group_request_viewmodel.dart';
import 'package:provider/provider.dart';

class JoinGroupRequestView extends StatefulWidget {
  const JoinGroupRequestView({super.key, this.groupId});
  final int? groupId;

  @override
  State<JoinGroupRequestView> createState() => _JoinGroupRequestViewState();
}

class _JoinGroupRequestViewState extends State<JoinGroupRequestView> {
  @override
  void initState()  {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<JoinGroupRequestViewmodel>().fetchList(widget.groupId!,true);
    },);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Gelen İstekler",
      ),
      body: Consumer<JoinGroupRequestViewmodel>(
        builder: (context, value, child) {
          if(value.isLoading==false){
            return const CustomLoadingWidget();
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: value.list.length,
            itemBuilder: (context, index) => JoinGroupPageItem(
              acceptUser: () async {
                await acceptUser(value.list[index], context);
              },
              rejectUser: () async {
                await rejectUser(value.list[index], context);
              },
              goUserProfile: () {
                goUserProfilePage(value.list[index].userId!);
              },
              userModel: value.list[index],
              groupId: widget.groupId!,
            ),
          );
        },
      ),
    );
  }

  void goUserProfilePage(String userId) {
    context.push("/other_user_profile", extra: userId);
  }

  Future<void> acceptUser(UserModel userModel, BuildContext context) async {
    var model = GroupJoinRequestModel(
        userId: userModel.userId, chatGroupId: widget.groupId, isAccept: true);
    try {
      var response = await context
          .read<JoinGroupRequestViewmodel>()
          .acceptOrReject(widget.groupId!,model.toJson());
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content:
                Text("${userModel.fullName} adlı kullanıcı kabul edildi.")));
      }
    } catch (e) {
      log("acceptUser", error: e.toString());
    }
  }

  Future<void> rejectUser(UserModel userModel, BuildContext context) async {
    var model = GroupJoinRequestModel(
        userId: userModel.userId, chatGroupId: widget.groupId, isAccept: false);
    try {
      var response = await context
          .read<JoinGroupRequestViewmodel>()
          .acceptOrReject(widget.groupId!,model.toJson());
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text("${userModel.fullName} adlı kullanıcı reddedildi.")));
      }
    } catch (e) {
      log("rejectUser", error: e.toString());
    }
  }
}

class JoinGroupPageItem extends StatelessWidget {
  const JoinGroupPageItem(
      {super.key,
      required this.userModel,
      required this.groupId,
      required this.acceptUser,
      required this.goUserProfile,
      required this.rejectUser});
  final UserModel userModel;
  final int groupId;
  final VoidCallback acceptUser;
  final VoidCallback rejectUser;
  final VoidCallback goUserProfile;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey, width: 1)),
      child: Row(
        children: [
          Column(
            children: [
              SizedBox(
                height: 70,
                width: 70,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(16)),
                  child: Image.network(
                    "${ApiConstants.baseUrl}/${userModel.profilePhotoPath}",
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Text(userModel.fullName!),
            ],
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                JoinGroupPageButtonWidget(
                  color: Colors.green,
                  onPressed: () {
                    acceptUser();
                  },
                  icon: Icons.check,
                ),
                JoinGroupPageButtonWidget(
                  color: Colors.red,
                  onPressed: () {
                    rejectUser();
                  },
                  icon: Icons.close,
                ),
                JoinGroupPageButtonWidget(
                  color: Colors.orange,
                  onPressed: () {
                    goUserProfile();
                  },
                  icon: Icons.remove_red_eye,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class JoinGroupPageButtonWidget extends StatelessWidget {
  const JoinGroupPageButtonWidget(
      {super.key,
      required this.color,
      required this.onPressed,
      required this.icon});
  final Color color;
  final VoidCallback onPressed;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ));
  }
}
