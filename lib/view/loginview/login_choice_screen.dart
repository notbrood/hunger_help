import 'package:flutter/material.dart';
import 'package:hunger_help/utils/colors.dart';
import 'package:hunger_help/utils/constants.dart';
import 'package:hunger_help/view/loginview/login_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "HH",
                style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 45),
              ),
              Text(
                "HUNGERHELP",
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen(
                                loginType: Constants.restaurantLoginType,
                              ))),
                  leading: Icon(
                    Icons.food_bank,
                    color: AppColors.white,
                  ),
                  title: Text(
                    "Login as a restaurant",
                    style: TextStyle(color: AppColors.white),
                  ),
                  tileColor: AppColors.primary,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen(
                                loginType: Constants.ngoLoginType,
                              ))),
                  leading: Icon(
                    Icons.people,
                    color: AppColors.white,
                  ),
                  title: Text(
                    "Login as a NGO",
                    style: TextStyle(color: AppColors.white),
                  ),
                  tileColor: AppColors.primary,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen(
                                loginType: Constants.donorLoginType,
                              ))),
                  leading: Icon(
                    Icons.person,
                    color: AppColors.white,
                  ),
                  title: Text(
                    "Login as a donor",
                    style: TextStyle(color: AppColors.white),
                  ),
                  tileColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
