import 'package:atlas/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _minButtonWidth = 220.0;
const _buttonHeight = 50.0;
const _elevation = 0.0;

class Home extends StatefulWidget {
  static final String route = "home";

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  Widget _getSignoutButton() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: double.infinity,
        child: MaterialButton(
          minWidth: _minButtonWidth,
          height: _buttonHeight,
          color: Colors.red,
          elevation: _elevation,
          child: Text(
            'Sign out',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          onPressed: () {
            print('Log out');
            Navigator.of(context)
                .pushNamed(Login.route); //todo  replace to pushReplacementNamed
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        automaticallyImplyLeading: false,
        elevation: _elevation,
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          _getSignoutButton(),
        ]),
      ),
      backgroundColor: Color.fromRGBO(241, 241, 241, 1),
    );
  }
}
