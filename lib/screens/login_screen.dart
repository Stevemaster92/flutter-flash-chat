import 'package:flash_chat/components/user_form.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static const String ROUTE = "/login";

  @override
  Widget build(BuildContext context) {
    return UserForm(isLogin: true);
  }
}
