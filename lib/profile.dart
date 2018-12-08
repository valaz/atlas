import 'package:atlas/login.dart';
import 'package:atlas/ui.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
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
            Navigator.of(context).pushReplacementNamed(
                Login.route); //todo  replace to pushReplacementNamed
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
          _getSignoutButton(context),
        ]),
      ),
      color: UI.backgroundColor,
    );
  }
}
