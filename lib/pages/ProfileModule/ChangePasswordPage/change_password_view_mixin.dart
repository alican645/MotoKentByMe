import 'package:flutter/material.dart';
import 'package:moto_kent/init/Helpers/local_storage.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/change_passsword_model.dart';
import 'package:moto_kent/pages/ProfileModule/ChangePasswordPage/change_password_view.dart';
import 'package:moto_kent/pages/ProfileModule/ChangePasswordPage/change_password_viewmodel.dart';
import 'package:provider/provider.dart';

mixin ChangePasswordViewMixin on State<ChangePasswordView> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  TextEditingController get controller  =>_controller;
  TextEditingController get controller2  =>_controller2;
  TextEditingController get controller3  =>_controller3;
  void showValidationFalseMessage();
  void passwordIsChanged();
  void passwordIsNotChange();
  void logout();

  bool validationPassword() {
    if ((_controller2.text != _controller3.text)||_controller2.text==""||_controller3.text=="") {
      showValidationFalseMessage();
      return true;
    }else{
      return false;
    }
  }

  Future<void> changePassword() async {
    if(validationPassword()){
      return;
    }
    LocalStorage storage = LocalStorageImpl();
    String? userId = await storage.getValue<String>("user_id");
    ChangePasswordModel model = ChangePasswordModel(
        userId: userId,
        newPassword: _controller3.text,
        oldPassword: _controller.text);
    if (!mounted) return;
    var result = await context
        .read<ChangePasswordViewmodel>()
        .changePasword(model.toJson());
    if (result == true) {
      passwordIsChanged();
      logout();
    } else {
      passwordIsNotChange();
    }
  }
}
