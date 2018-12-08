import 'package:atlas/home.dart';
import 'package:atlas/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  FirebaseUser _currentUser;

  @override
  void initState() {
    super.initState();
    if (_currentUser == null) {
      getCurrentUser().then((FirebaseUser user) {
        if (user != null) {
          print('Home user: ${user.uid}');
          _currentUser = user;
        }
      });
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_currentUser == null) {
      FirebaseUser user = await firebaseAuth.currentUser();
      setState(() {
        _currentUser = user;
      });
    }
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser = await firebaseAuth.currentUser();
    if (currentUser != null) {
      return currentUser;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser != null) {
      return Home(user: _currentUser);
    }
    return Login();
  }
}
