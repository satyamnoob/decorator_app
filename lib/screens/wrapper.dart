import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/my_user.dart';
import 'authenticate/authenticate.dart';
import 'home/home_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    if(user == null) {
      return const Authenticate();
    }
    else {
      return HomeScreen();
    }
  }
}