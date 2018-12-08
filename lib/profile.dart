import 'package:atlas/login.dart';
import 'package:atlas/ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final FirebaseUser user;

  const Profile({Key key, this.user}) : super(key: key);

  Widget _getSignoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: double.infinity,
        child: MaterialButton(
          minWidth: UI.minButtonWidth,
          height: UI.buttonHeight,
          color: Colors.red,
          elevation: UI.elevation,
          child: Text(
            'Log out',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          onPressed: () {
            print('Log out');
            FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacementNamed(Login.route);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text(user.email,
            style: TextStyle(
              color: Colors.green,
            ),
          ),
          _getSignoutButton(context),
        ]),
      ),
      color: UI.backgroundColor,
    );
  }
}
