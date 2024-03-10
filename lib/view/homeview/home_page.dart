import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hunger_help/methods/firebase_database_services.dart';
import 'package:hunger_help/utils/constants.dart';
import 'package:hunger_help/view/detailsview/details_view_ngo.dart';
import 'package:hunger_help/view/detailsview/details_view_restaurant.dart';
import 'package:hunger_help/view/detailsview/details_view_user.dart';
import 'package:hunger_help/view/homeview/home_page_donor.dart';
import 'package:hunger_help/view/homeview/home_page_ngo.dart';
import 'package:hunger_help/view/homeview/home_page_restaurant.dart';
import 'package:hunger_help/view/settings_view/profile_view.dart';
import 'package:hunger_help/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String userType;
  const HomePage({super.key, required this.userType});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    userType = widget.userType;
    setState(() {});
    check();
    super.initState();
  }

  check() async {
    final prefs = await SharedPreferences.getInstance();
    String s = prefs.get("userType") as String;
    userType = s;
    DataSnapshot d = await FirebaseDB().getUser(s);
    context.read<UserVm>().setUser(User(
        userType: s,
        data: d.value as Map<dynamic, dynamic>,
        uid: auth.FirebaseAuth.instance.currentUser!.uid));

    if (context.read<UserVm>().user.data == null) {
      if (context.read<UserVm>().user.userType == "donor") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DetailsViewDonor()),
            (route) => false);
      } else if (context.read<UserVm>().user.userType == "restaurant") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DetailsViewRestaurant()),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DetailsViewNGO()),
            (route) => false);
      }
      setState(() {});
    }
  }

  String userType = "ngo";
  @override
  Widget build(BuildContext context) {
    if (userType == Constants.restaurantLoginType) {
      return HomePageRestaurant();
    } else if (userType == Constants.donorLoginType) {
      return HomePageDonor();
    } else {
      return HomePageNGO();
    }
  }
}
