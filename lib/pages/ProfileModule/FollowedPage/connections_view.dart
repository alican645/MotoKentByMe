import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/custom_app_bar.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/models/connection_model.dart';
import 'package:moto_kent/pages/AppBarModule/MyNotificationsPage/my_notifications_view.dart';
import 'package:moto_kent/pages/ProfileModule/FollowedPage/connections_viewmodel.dart';
import 'package:provider/provider.dart';


class ConnectionsView extends StatefulWidget {
  const ConnectionsView({super.key});

  @override
  _ConnectionsViewState createState() => _ConnectionsViewState();
}

class _ConnectionsViewState extends State<ConnectionsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      context.read<ConnectionsViewmodel>().fetchConnections();
    },);

  }


  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionsViewmodel>(
      builder: (context, value, child) {
        if(value.isLoading==false){
          return CustomLoadingWidget();
        }
       return Scaffold(
        appBar: CustomAppBar(
          title: "Bağlantılar",
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            labelStyle:const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            tabs:  [
              Tab(text: value.followerCount.toString(),),
              Tab(text: value.followedCount.toString(),),
            ],
          ),
        ),
        body:
            TabBarView(
            controller: _tabController,
            children: [
              UserList(
                list: Provider.of<ConnectionsViewmodel>(context).followerList,
              ),
              UserList(
                list: Provider.of<ConnectionsViewmodel>(context).followedList,
              ),

            ],
          ));
          },
        );
  }
}

class UserList extends StatelessWidget {
  UserList({super.key,required this.list });
  final List<ConnectionModel> list;
  @override
  Widget build(BuildContext context) {


    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return UserListItem(
          user: list[index],
          index: index,

        );
      },
    );
  }
}

class UserListItem extends StatelessWidget {
  final ConnectionModel user;
  final int index;


  const UserListItem({super.key, required this.user,required this.index});



  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        context.push(AppRoutes.otherUserProfile,extra: user.userId);
      },
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage("${ApiConstants.baseUrl}/${user.profilePhotoPath}"),
      ),
      title: Text(user.fullName!,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      trailing: user.isFollowing==false?_FollowButton(
        onPressed: () async {

          var result = await context.read<ConnectionsViewmodel>()
              .followUser(user.userId!);
          if(result){
          }
        }
      ): _RemoveButton(onPressed: () {
        var result=context.read<ConnectionsViewmodel>().unfollowUser(user.userId!, index);
      },)


    );
  }
}

class _FollowButton extends StatelessWidget {

  final VoidCallback onPressed;

  const _FollowButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        'Takip Et',
        style: TextStyle(
          color:  Colors.black,
          fontSize: 14,
        ),
      ),
      style: ElevatedButton.styleFrom(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
      onPressed: onPressed,
    );
  }
}

class _RemoveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _RemoveButton({super.key, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        'Kaldır',
        style: TextStyle(color: Colors.red, fontSize: 14),
      ),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
      onPressed: onPressed
    );
  }
}

