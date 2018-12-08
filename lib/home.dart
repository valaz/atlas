import 'package:atlas/achievements.dart';
import 'package:atlas/geo.dart';
import 'package:atlas/profile.dart';
import 'package:atlas/ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  static final String route = "home";

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    Geo(),
    Achievements(UI.backgroundColor),
    Profile(),
  ];


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
        title: Text(_getTitle()),
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
