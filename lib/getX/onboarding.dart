import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:home_plant/screens/auth_screen.dart';
import 'package:home_plant/screens/home_page.dart';
import 'package:home_plant/screens/onboarding_page.dart';
import 'package:home_plant/screens/splash_screen.dart';

class OnBoardingGetX extends GetxController {

  final box = GetStorage();
  bool get isFirstUse => box.read('isFirst') ?? false;
  Widget get firstPage => isFirstUse
      ? StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            }
            if (snapshot.hasData) {
              return HomePage();
            }
            return AuthScreen();
          },
        )
      : OnBoardingPage();
  void changeIsFirst(bool value) => box.write('isFirst', value);
}
