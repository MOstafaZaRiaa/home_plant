import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {

  bool _isDarkThemeEnabled = false;
  bool get isDarkThemeEnabled {
    return _isDarkThemeEnabled;
  }

  Future<void> setIsDarkThemeEnabled(bool isDarkThemeEnabled)async{
    _isDarkThemeEnabled = isDarkThemeEnabled;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('MODE',isDarkThemeEnabled);
    notifyListeners();
  }
  // Future<void> loadData()async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _isDarkThemeEnabled = prefs.getBool('MODE') ?? true;
  //
  // }
}
