import 'package:flash_chat/components/user_form.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatelessWidget {
  static const String ROUTE = "/register";

  @override
  Widget build(BuildContext context) {
    return UserForm(isLogin: false);
  }
}
