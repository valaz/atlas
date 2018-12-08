import 'package:atlas/achievements.dart';
import 'package:atlas/geo.dart';
import 'package:atlas/profile.dart';
import 'package:atlas/ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  static final String route = "home";
  final FirebaseUser user;

  const Home({Key key, this.user}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    Geo(),
    Achievements(UI.backgroundColor),
    Profile(),
  ];


  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _children[2] = Profile(user: widget.user);
    }
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  String _getTitle() {
    switch (_currentIndex) {
      case(0):
        return 'Home';
        break;
      case(1):
        return 'Achievements';
        break;
      case(2):
        return 'Profile';
        break;
      default:
        return 'Home';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(),
          style: TextStyle(
            color: Theme
                .of(context)
                .accentColor,
          ),),
        elevation: UI.elevation,
      ),
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            title: Text('Home'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.local_play),
            title: Text('Achievements'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile')
          )
        ],
      ),
    );
  }
}
