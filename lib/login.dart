import 'package:atlas/home.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

const _minButtonWidth = 220.0;
const _buttonHeight = 50.0;
const _elevation = 0.0;

class Login extends StatefulWidget {
  static final String route = "login";

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  Widget _getLoginButton(Color color, String name, IconData iconKey) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: double.infinity,
        child: MaterialButton(
          minWidth: _minButtonWidth,
          height: _buttonHeight,
          color: color,
          elevation: _elevation,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Icon(iconKey),
              ),
              Text(
                name,
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ],
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
              _getLoginButton(
                  Color.fromRGBO(66, 103, 178, 1),
                  'Login with Facebook',
                  MdiIcons.facebook),
              _getLoginButton(
                  Color.fromRGBO(219, 50, 54, 1),
                  'Login with Google',
                  MdiIcons.google),
              _getLoginButton(
                  Colors.blueGrey,
                  'Anonymous',
                  MdiIcons.incognito),
            ],
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(241, 241, 241, 1),
    );
  }
}
