import 'package:flutter/material.dart';

class UserVm with ChangeNotifier {
  late User user;
  setUser(User user) {
    this.user = user;
  }

  getUser() {
    return user;
  }
}

class User {
  String userType;
  Map? data;
  String uid;

  User({required this.userType, required this.data, required this.uid});
}
