import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:ss_pool/screens/dashboard.dart';
import 'package:ss_pool/screens/driverscreen.dart';
import 'package:ss_pool/screens/loginpage.dart';
import 'package:ss_pool/screens/profilescreen.dart';
import 'package:ss_pool/screens/ridesscreen.dart';
import 'package:ss_pool/screens/userscreen.dart';

import 'services/transitionService.dart';

void main() {
  setUrlStrategy(const HashUrlStrategy());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF1E1E2F),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            // Apply no-animation transition on all platforms
            TargetPlatform.android: NoTransitionsBuilder(),
            TargetPlatform.iOS: NoTransitionsBuilder(),
            TargetPlatform.linux: NoTransitionsBuilder(),
            TargetPlatform.macOS: NoTransitionsBuilder(),
            TargetPlatform.windows: NoTransitionsBuilder(),
            TargetPlatform.fuchsia: NoTransitionsBuilder(),
          },
        ),
      ),
      home: LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const Dashboard(),
        '/users': (context) => UserScreen(),
        '/drivers': (context) => DriverScreeen(),
        '/rides': (context) => RideScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}
