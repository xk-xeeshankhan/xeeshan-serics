import 'package:flutter/material.dart';
import 'package:serictest/splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  ///the starting point of application\
  ///show splash screen
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
