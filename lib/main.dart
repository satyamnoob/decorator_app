import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decorator_app/screens/home/profile_screen.dart';
import 'package:decorator_app/services/auth.dart';
import 'package:decorator_app/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'models/my_user.dart';
import 'screens/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<MyUser?>.value(value: AuthService().user, initialData: null, catchError: ((context, error) {}),),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        debugShowCheckedModeBanner: false,
        home: const Wrapper(),
        routes: {
          ProfileScreen.routeName:(context) => ProfileScreen(),
        },
      ),
    );
  }
}
