

import 'package:flutter/material.dart';
import 'package:moto_kent/init/Helpers/local_storage.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/change_email_model.dart';
import 'package:moto_kent/pages/ProfileModule/ChangeEmailPage/change_email_view.dart';
import 'package:moto_kent/pages/ProfileModule/ChangeEmailPage/change_email_viewmodel.dart';
import 'package:provider/provider.dart';

mixin ChangeEmailViewMixin on State<ChangeEmailView>{
  final  TextEditingController _controller = TextEditingController();
  final  TextEditingController _controller2 = TextEditingController();
  final  TextEditingController _controller3 = TextEditingController();

  TextEditingController get controller  =>_controller;
  TextEditingController get controller2  =>_controller2;
  TextEditingController get controller3  =>_controller3;

  void showValidationFalseMessage();
  void showValidationNotEmailFormatMessage();
  void emailIsChanged();
  void emailIsNotChange();

  Future<void> changeEmail(ChangeEmailViewmodel vm) async {
    if( validationPassword() ||validationEmail() ){
      return;
    }
    LocalStorage storage = LocalStorageImpl();
    String? userId = await storage.getValue<String>("user_id");
    ChangeEmailModel model=ChangeEmailModel(
      userId: userId,
      password: controller2.text,
      newEmail: controller.text,
    );
    if (!mounted) return;
    var result =await context.read<ChangeEmailViewmodel>().changePasword(model.toJson());
    if (result == true) {
      emailIsChanged();
    } else {
      emailIsNotChange();
    }
  }

  bool validationPassword() {
    if ((_controller2.text != _controller3.text)||_controller2.text==""||_controller3.text=="") {
      showValidationFalseMessage();
      return true;
    }else{
      return false;
    }

  }

  bool validationEmail(){
    // Basit bir email formatı doğrulaması
    String? value=_controller.text;
    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
      showValidationNotEmailFormatMessage();
      return true;
    }else{
      return false;
    }

  }
}