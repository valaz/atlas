import 'package:atlas/home.dart';
import 'package:flutter/material.dart';

const _minButtonWidth = 220.0;
const _buttonHeight = 50.0;
const _elevation = 0.0;

class Login extends StatefulWidget {
  static final String route = "login";

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  Widget _getLoginButton(Color color, String name) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: double.infinity,
        child: MaterialButton(
          minWidth: _minButtonWidth,
          height: _buttonHeight,
          color: color,
          elevation: _elevation,
          child: Text(
            name,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          onPressed: () {
            print('$name');
            Navigator.of(context)
                .pushReplacementNamed(Home.route); //todo use firebase auth
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log in"),
        automaticallyImplyLeading: false,
        elevation: _elevation,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _getLoginButton(Color.fromRGBO(59, 89, 152, 1), 'Login with Facebook'),
              _getLoginButton(Color.fromRGBO(219, 50, 54, 1), 'Login with Google'),
              _getLoginButton(Colors.blueGrey, 'Anonymous'),
            ],
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(241, 241, 241, 1),
    );
  }
}
