import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hunger_help/methods/firebase_database_services.dart';
import 'package:hunger_help/view/loginview/login_choice_screen.dart';
import 'package:hunger_help/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final String userType;
  const SettingsPage({super.key, required this.userType});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  check() async {
    DataSnapshot d = await FirebaseDB().getUser(widget.userType);
    context.read<UserVm>().setUser(User(
        userType: widget.userType,
        data: d.value as Map<dynamic, dynamic>,
        uid: auth.FirebaseAuth.instance.currentUser!.uid));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileCard(
              name: context.read<UserVm>().user.data == null
                  ? ""
                  : context.read<UserVm>().user.data?["name"],
              userType: widget.userType,
            ),
            SizedBox(height: 20.0),
            ListTile(
              title: Text('About App'),
              onTap: () {
                // Handle Option 1
              },
            ),
            widget.userType != "donor"
                ? ListTile(
                    title: Text('UPI QR'),
                    onTap: () {
                      // Handle Option 2
                    },
                  )
                : SizedBox(),
            SizedBox(height: 20.0),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Handle Logout
                auth.FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                minimumSize: Size(double.infinity, 40.0),
              ),
              child: Text('Logout'),
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String name;
  final String userType;

  ProfileCard({
    required this.name,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Profile',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Name: $name',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'User Type: $userType',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
