import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

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

class ThemeProvide extends GetxController {
  
  final box = GetStorage();
  bool get isDark => box.read('darkmode') ?? false;
  ThemeData get theme => isDark ? dark : light;
  void changeTheme(bool val) => box.write('darkmode', val);
}
