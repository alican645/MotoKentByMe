import 'package:flutter/material.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/constants/data_objects.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/models/user_model.dart';
import 'package:moto_kent/pages/GroupsPage/GroupSettingPage/group_setting_view_nodel.dart';
import 'package:moto_kent/pages/GroupsPage/MyChatGroupsPage/my_groups_viewmodel.dart';
import 'package:moto_kent/pages/GroupsPage/groups_viewmodel.dart';
import 'package:provider/provider.dart';

class GroupSettingView extends StatelessWidget {
  final String? groupId;
  const GroupSettingView({super.key, this.groupId});



  @override
  Widget build(BuildContext context) {
    Future<void> leaveGroup() async{
      String? userId=await SharedPreferencesHelper().getValue<String>("user_id");
      var response=await context.read<GroupSettingViewmodel>().leaveGroup(DataObjects.joinGroup(groupId!, userId!));
      if(response.statusCode==200){
        await context.read<MyGroupsViewmodel>().fetchMyChatGroups();
        await Future.delayed(const Duration(seconds: 1));
        await context.read<ChatGroupsViewmodel>().fetchChatGropsList();
        Navigator.popUntil(context, (route) => route.settings.name == "my_groups");
      }
    }
    String groupIdd = groupId as String;

    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: context.read<GroupSettingViewmodel>().fetchGroupData(groupIdd),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: const CustomLoadingWidget(),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,

            children: [
              GroupIconWidget(
                iconPath: snapshot.data!.groupIconPath!,
              ),
              Text(
                snapshot.data!.name!,
                style: const TextStyle(fontSize: 25),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: ListView.builder(
                      itemCount: snapshot.data!.users!.length,
                        itemBuilder: (context, index) => MemberCardItem(
                              userModel: snapshot.data!.users![index],
                              onPressed: () {},
                            )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () async {
                    await leaveGroup();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(90)
                    ),
                    child: const Text("Gruptan Ayrıl",style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    ),),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class GroupIconWidget extends StatelessWidget {
  const GroupIconWidget({super.key, required this.iconPath});
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(
          '${ApiConstants.baseUrl}/$iconPath',
        ),
        child: Container(
          width: 102,
          height: 102,
          decoration: BoxDecoration(
              border:
                  Border.all(color: AppTheme.themeData.primaryColor, width: 3),
              borderRadius: BorderRadius.circular(90)),
        ),
      ),
    );
  }
}

class MemberCardItem extends StatelessWidget {
  const MemberCardItem({
    super.key,
    required this.userModel,
    required this.onPressed,
  });
  final UserModel userModel;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(90),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  radius: 30,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage('${ApiConstants.baseUrl}/${userModel.profilePhotoPath}'),

                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        userModel.fullName!,
                        style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 4.0),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
