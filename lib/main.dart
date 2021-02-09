import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_plant/getX/theme.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'getX/onboarding.dart';

Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Get.put(ThemeProvide());
    final onBoarding = Get.put(OnBoardingGetX());
    return SimpleBuilder(
      builder: (_) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Home Plant',
          theme: themeProvider.theme,
          home: SimpleBuilder(
            builder: (BuildContext context) => onBoarding.firstPage,
          ),
        );
      },
    );
  }
}
