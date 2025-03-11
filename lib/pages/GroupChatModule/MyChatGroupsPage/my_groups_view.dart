import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/chat_group_item_2.dart';
import 'package:moto_kent/components/custom_app_bar_widget.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/pages/GroupChatModule/MyChatGroupsPage/my_groups_viewmodel.dart';
import 'package:provider/provider.dart';

class MyGroupsView extends StatefulWidget {
  const MyGroupsView({super.key});
  @override
  State<MyGroupsView> createState() => _MyGroupsView();
}

class _MyGroupsView extends State<MyGroupsView> {


  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<MyGroupsViewmodel>().fetchMyChatGroups();
    },);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar22( 
      ),
      body: Column(
        children: [
          Flexible(
            child: Consumer<MyGroupsViewmodel>(
              builder: (contextt, value, child) {

                return ListView.builder(
                itemCount: value.groupsList.length,
                itemBuilder: (contextt, index) => ChatGroupItem2(
                  amIAdmin: value.groupsList[index].amIAdmin,
                  group: value.groupsList[index],
                  onTap: () async {
                    goToMessagePage(value, index, context);
                  },
                ),
              );
              },
            ),
          ),
        ],
      ),
    );
  }

  void goToMessagePage(MyGroupsViewmodel value, int index, BuildContext context) async {
     String? userId= await LocalStorageImpl().getValue<String>("user_id");
    Map<String, dynamic> object = {
      "userId": userId!,
      "groupId": value.groupsList[index].chatGroupId!,
      "userName": "username",
      "groupName": value.groupsList[index].name!
    };
    context.push(AppRoutes.messagePage,
        extra: object);

  }
}
