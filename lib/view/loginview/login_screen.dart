import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hunger_help/methods/firebase_database_services.dart';
import 'package:hunger_help/utils/constants.dart';
import 'package:hunger_help/utils/util_functions.dart';
import 'package:hunger_help/view/detailsview/details_view_ngo.dart';
import 'package:hunger_help/view/detailsview/details_view_restaurant.dart';
import 'package:hunger_help/view/detailsview/details_view_user.dart';
import 'package:hunger_help/view/homeview/home_page.dart';
import 'package:hunger_help/viewmodels/user_viewmodel.dart' as uservm;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final String loginType;
  const LoginScreen({super.key, required this.loginType});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "HH",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 45),
          ),
          const Text(
            "HUNGERHELP",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text("Login as ${widget.loginType.toUpperCase()} to continue"),
          const SizedBox(
            height: 30,
          ),
          Center(
              child: GoogleSignInButton(
            userType: widget.loginType,
          ))
        ],
      ),
    );
  }
}

class GoogleSignInButton extends StatefulWidget {
  final String userType;
  const GoogleSignInButton({super.key, required this.userType});

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;
  ValueNotifier userCredential = ValueNotifier('');
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });
                try {
                  userCredential.value = await signInWithGoogle();
                  if (userCredential.value != null) {
                    DataSnapshot userRef =
                        await FirebaseDB().getUser(widget.userType);
                    if (userRef.exists) {
                      context.read<uservm.UserVm>().user = uservm.User(
                          userType: widget.userType,
                          data: userRef.value as Map<dynamic, dynamic>,
                          uid: FirebaseAuth.instance.currentUser!.uid);
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString("userType", widget.userType);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                    userType: widget.userType,
                                  )));
                    } else {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString("userType", widget.userType);
                      if (widget.userType == Constants.restaurantLoginType) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailsViewRestaurant()));
                      } else if (widget.userType == Constants.ngoLoginType) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailsViewNGO()));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const DetailsViewDonor()));
                      }
                    }
                  }
                } catch (e) {
                  // Handle sign-in error
                  UtilFunctions().showSnackbar(
                      context, "Error signing in with Google: $e");
                }
                setState(() {
                  _isSigningIn = false;
                });
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/images/google_logo.png"),
                      height: 35.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print(googleUser!.displayName);
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      // TODO
      print('exception->$e');
      rethrow;
    }
  }
}
