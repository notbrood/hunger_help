import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hunger_help/utils/constants.dart';

class FirebaseDB {
  FirebaseDatabase _database = FirebaseDatabase.instance;

  createUser(String userType, Map data) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    _database.ref("/$userType/$uid").set(data);
  }

  getUser(String userType) async {
    var user = await _database
        .ref("/$userType/${FirebaseAuth.instance.currentUser!.uid}")
        .get();
    return user;
  }
}
