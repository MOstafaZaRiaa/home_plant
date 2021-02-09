import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:home_plant/screens/auth_screen.dart';
import 'package:home_plant/screens/home_page.dart';
import 'package:home_plant/screens/splash_screen.dart';

class SwitchBetweenFirstPages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
        );
  }
}
