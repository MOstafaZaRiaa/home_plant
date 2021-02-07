import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:home_plant/providers/theme_provider.dart';
import 'package:home_plant/screens/auth_screen.dart';
import 'package:home_plant/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        // Used MultiProvider incase you have other providers
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool themeEnabled=false;
  // Future<bool> getData() async {
  //   bool _isDarkThemeEnabled;
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _isDarkThemeEnabled = prefs.getBool('MODE') ?? true;
  //   themeEnabled = _isDarkThemeEnabled;
  //   Provider.of<ThemeProvider>(context, listen: false)
  //       .setIsDarkThemeEnabled(_isDarkThemeEnabled);
  //   return _isDarkThemeEnabled;
  // }
  @override
  void initState() {
    // getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Plant',
      theme: themeEnabled
          ? ThemeData.dark().copyWith(
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
            )
          : ThemeData(
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
            ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }
          if (snapshot.hasData) {
            // return FeatureDiscovery(
            //   child: HomePage(),
            // );
            return HomePage();
          }
          return AuthScreen();
        },
      ),
      routes: {

      },
    );
  }
}
