import 'package:atlas/home.dart';
import 'package:atlas/ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

const String testEmail = 'test@test.com';
const String testPassword = '111111';

class Login extends StatefulWidget {
  static final String route = "login";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser = await firebaseAuth.currentUser();
    if (currentUser != null) {
      return currentUser;
    }
    return null;
  }

  void _facebookLogin() {
    Fluttertoast.showToast(
        msg: "Facebook login is not supported",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        backgroundColor: Theme
            .of(context)
            .primaryColor
    );
  }

  void _googleLogin() {
    Fluttertoast.showToast(
        msg: "Google login is not supported",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        backgroundColor: Theme
            .of(context)
            .primaryColor
    );
  }

  // todo remove
  void _testLogin() {
    firebaseAuth.signInWithEmailAndPassword(
        email: testEmail, password: testPassword)
        .then((firebaseUser) async {
      if (firebaseUser != null) {
        // Check is already sign up
        await saveUserToCollection(firebaseUser);
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => Home(user: firebaseUser),
        ),
      ).catchError((e) => print(e));
    }).catchError((e) {
      print(e);
    });
  }


  Future saveUserToCollection(FirebaseUser firebaseUser) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: firebaseUser.uid)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 0) {
      // Update data to server if new user
      Firestore.instance
          .collection('users')
          .document(firebaseUser.uid)
          .setData({
        'nickname': firebaseUser.displayName,
        'email': firebaseUser.email,
        'phone': firebaseUser.phoneNumber,
        'photoUrl': firebaseUser.photoUrl,
        'id': firebaseUser.uid,
      });
    }
  }

  Widget _getLoginButton(Color color, String name, IconData iconKey,
      Function onPressed) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: double.infinity,
        child: MaterialButton(
          minWidth: UI.minButtonWidth,
          height: UI.buttonHeight,
          color: color,
          elevation: UI.elevation,
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
            onPressed: onPressed
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
        elevation: UI.elevation,
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
                  MdiIcons.facebook,
                  _facebookLogin),
              _getLoginButton(
                  Color.fromRGBO(219, 50, 54, 1),
                  'Login with Google',
                  MdiIcons.google,
                  _googleLogin),
              _getLoginButton(
                  Colors.blueGrey,
                  'Test login',
                  MdiIcons.debugStepOver,
                  _testLogin),
            ],
          ),
        ),
      ),
      backgroundColor: UI.backgroundColor,
    );
  }
}
