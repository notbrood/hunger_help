import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hunger_help/methods/firebase_database_services.dart';
import 'package:hunger_help/utils/colors.dart';
import 'package:hunger_help/view/homeview/home_page.dart';
import 'package:hunger_help/view/loginview/login_choice_screen.dart';
import 'package:hunger_help/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      if (auth.FirebaseAuth.instance.currentUser != null) {
        // getUserFr();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      userType: userType,
                    )));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    });
    super.initState();
  }

  String userType = "donor";

  void getUserFr() async {
    print("getuser");
    final prefs = await SharedPreferences.getInstance();
    String s = prefs.get("userType") as String;
    DataSnapshot d = await FirebaseDB().getUser(s);
    context.read<UserVm>().setUser(User(
        userType: s,
        data: d.value as Map<dynamic, dynamic>,
        uid: auth.FirebaseAuth.instance.currentUser!.uid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "HH",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 45),
            ),
            Text(
              "HUNGERHELP",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
