import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
  primaryColor: Color(0xFF0B9E74),
  accentColor: Color(0xFFFEC182),
  backgroundColor: Color(0xFFF8F9FB),
  textTheme: TextTheme(
    headline1: TextStyle(
      color: Color(0xFF0B9E74),
    ),
  ),
  accentTextTheme: TextTheme(
    headline1: TextStyle(
      color: Color(0xFFFFFFFF),
    ),
  ),
  fontFamily: 'Roboto',
);

ThemeData dark = ThemeData.dark().copyWith(
  accentTextTheme: TextTheme(
    headline1: TextStyle(
      color: Color(0xFFFFFFFF),
    ),
  ),
  textTheme: TextTheme(
    headline1: TextStyle(
      color: Color(0xFFFFFFFF),
    ),
  ),
);

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences _prefs;
  bool _darkTheme;

  bool get darkTheme => _darkTheme;

  ThemeNotifier() {
    _darkTheme = true;
    _loadFromPrefs();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    if(_prefs == null)
      _prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = _prefs.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs()async {
    await _initPrefs();
    _prefs.setBool(key, _darkTheme);
  }

}