import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:seekyouapp/data/manager/user.dart';
import 'package:seekyouapp/ui/constant/DevConstant.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool
class UserProvider with ChangeNotifier, DiagnosticableTreeMixin {
  int _count = 0;
  int get count => _count;

  String _userPhoto = DevConstant.CONST_PIC;
  String get userPhoto => _userPhoto;

  String _userName = "name";
  String get userName => _userName;
  String _userDesc = "I declare...";
  String get userDesc => _userDesc;

  void increment() {
    _count++;
    notifyListeners();
  }

  void updatePhoto(String photo) {
    if (photo == null) return;
    _userPhoto = photo;
    notifyListeners();
    print("updatePhoto");
  }
  
  void updateUser(User user) {
    if (user.userName != null) {
      _userName = user.userName;
    }
    if (user.userDesc != null) {
      _userDesc = user.userDesc;
    }
    notifyListeners();
    print("updateUser");
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', count));
    properties.add(StringProperty('userPhoto', userPhoto));
    properties.add(StringProperty('userName', userName));
    properties.add(StringProperty('userDesc', userDesc));
  }
}