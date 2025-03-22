import 'package:flutter/material.dart';
import 'package:moto_kent/pages/ProfileModule/AccountSecurityPage/account_security_view.dart';

mixin AccountSecurityViewMixin on State<AccountSecurityView> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  TextEditingController get controller => _controller;
  TextEditingController get controller2 => _controller2;
}
