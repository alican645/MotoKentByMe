
import 'package:flutter/material.dart';
import 'package:moto_kent/models/user_model.dart';
import 'package:moto_kent/pages/ProfileModule/EditProfilePage/edit_profile_view.dart';
import 'package:moto_kent/pages/ProfileModule/EditProfilePage/edit_profile_viewmodel.dart';
import 'package:provider/provider.dart';

mixin EditProfileViewMixin on State<EditProfileView> {
  final TextEditingController _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;

  final TextEditingController _bioController = TextEditingController();
  TextEditingController get bioController => _bioController;





  UserModel2? userModel;

  Future<void> initialize(BuildContext context) async {
    await context.read<EditProfileViewmodel>().fetchData();
    if (!mounted) return;
    userModel =
        Provider.of<EditProfileViewmodel>(context, listen: false).userModel;
    _nameController.text = userModel!.fullName!;
    _bioController.text = userModel!.bio ?? "";

    setState(() {});
  }
}
