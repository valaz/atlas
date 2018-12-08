import 'package:atlas/home.dart';
import 'package:atlas/login.dart';
import 'package:atlas/start.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final routes = <String, WidgetBuilder>{
    Login.route: (BuildContext context) => Login(),
    Home.route: (BuildContext context) => Home(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Atlas',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color.fromRGBO(52, 48, 45, 1),
        accentColor: Color.fromRGBO(115, 179, 48, 1),
        primaryTextTheme: TextTheme(
          title: TextStyle(
            color: Color.fromRGBO(238, 238, 238, 1),
          ),
        ),
      ),
      home: Start(),
      routes: routes,
    );
  }
}
