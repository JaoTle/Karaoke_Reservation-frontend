
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:karaoke_reservation/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _activeUser;
  setActiveUser(UserModel user) {
    _activeUser = user;
    notifyListeners();
  }

  UserModel get activeUser => _activeUser!;
}