import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:corazon_customerapp/src/di/app_injector.dart';
import 'package:corazon_customerapp/src/repository/auth_repository.dart';

class FirebaseAuthProvider with ChangeNotifier {
  var authRepo = AppInjector.get<AuthRepository>();
  FirebaseUser _firebaseUser;

  FirebaseUser get firebaseUser => _firebaseUser;

  set firebaseUser(FirebaseUser value) {
    _firebaseUser = value;
    notifyListeners();
  }
}
