
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_instagram/resources/auth_user.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier{
  final Auth = AuthMethods();
  Member? _user;
  bool _loading= false;

  Member? get getUser => _user;
  bool get isLoaging => _loading;

  Future<void> refreshUser() async{
    _loading = true;
    Member? member = await Auth.getUserDetails();
    _user = member;
    _loading = false;
    notifyListeners();
  }
}