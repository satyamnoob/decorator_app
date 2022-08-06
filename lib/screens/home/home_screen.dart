import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decorator_app/models/my_user.dart';
import 'package:decorator_app/services/database.dart';
import 'package:decorator_app/services/loading.dart';
import 'package:decorator_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../services/auth.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    final MyUserData? myUserData = Provider.of<MyUserData?>(context);
     
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          TextButton.icon(
            onPressed: () {
              _auth.signOut();
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            label: Text(
              'Logout',
              style: GoogleFonts.sourceSansPro(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      drawer: DrawerWidget(),
      body: StreamBuilder<MyUserData?>(
        stream: DatabaseService(uid: user!.uid).userData,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return Text(snapshot.data!.email!);
          }
          else {
            return const Loading();
          }
        }
      ),
    );
  }
}
