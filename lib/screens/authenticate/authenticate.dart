import 'package:decorator_app/screens/authenticate/register.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool isLogin = false;
  void toggleView() {
    setState(() {
      isLogin = !isLogin;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return LoginScreen(toggleView: toggleView);
    } else {
      return RegisterSreen(toggleView: toggleView);
    }
  }
}
