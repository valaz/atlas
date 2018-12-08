import 'dart:io';

import 'package:atlas/login.dart';
import 'package:atlas/ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final FirebaseUser user;

  const Profile({Key key, this.user}) : super(key: key);

  @override
  State createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController controllerNickname;

  SharedPreferences prefs;

  String id = '';
  String nickname = '';
  String email = '';
  String photoUrl = '';

  bool isLoading = false;
  File avatarImageFile;

  final FocusNode focusNodeNickname = new FocusNode();

  @override
  void initState() {
    super.initState();
    readLocal();
    readRemote();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    nickname = prefs.getString('nickname') ?? '';
    email = prefs.getString('email') ?? '';
    photoUrl = prefs.getString('photoUrl') ?? '';
    controllerNickname = new TextEditingController(text: nickname);

    setState(() {});
  }

  void readRemote() async {
    prefs = await SharedPreferences.getInstance();
    DocumentSnapshot snapshot = await Firestore.instance.collection('users')
        .document(widget.user.uid)
        .get();
    id = snapshot.data['id'] ?? '';
    nickname = snapshot.data['nickname'] ?? '';
    email = snapshot.data['email'] ?? '';
    photoUrl = snapshot.data['photoUrl'] ?? '';
    controllerNickname = new TextEditingController(text: nickname);


    await prefs.setString('nickname', nickname);
    await prefs.setString('photoUrl', photoUrl);

    setState(() {});
  }

  Widget _getUserInfo() {
    return Column(
      children: <Widget>[
        _getAvatarWidget(),
        _getNicknameWidget(),
      ],
    );
  }

  Widget _getAvatarWidget() {
    return Container(
      child: Center(
        child: Stack(
          children: <Widget>[
            (avatarImageFile == null)
                ? (photoUrl != ''
                    ? Material(
                        child: CachedNetworkImage(
                          placeholder: Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(UI.green),
                            ),
                            width: 200.0,
                            height: 200.0,
                            padding: EdgeInsets.all(20.0),
                          ),
                          imageUrl: photoUrl,
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 200.0,
                        color: Colors.redAccent,
                      ))
                : Material(
                    child: Image.file(
                      avatarImageFile,
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    clipBehavior: Clip.hardEdge,
                  ),
            IconButton(
              icon: Icon(
                Icons.camera_alt,
                color: Colors.grey[100].withOpacity(0.5),
              ),
              onPressed: getImage,
              padding: EdgeInsets.all(75.0),
              splashColor: Colors.transparent,
              highlightColor: UI.black,
              iconSize: 50.0,
            ),
          ],
        ),
      ),
      width: double.infinity,
      margin: EdgeInsets.all(20.0),
    );
  }

  Widget _getNicknameWidget() {
    return Column(children: [
      Container(
        child: Theme(
          data: new ThemeData(
              primaryColor: Theme.of(context).accentColor,
              primaryColorDark: Theme.of(context).accentColor,
              hintColor: Theme.of(context).textTheme.display1.color),
          child: TextField(
            decoration: InputDecoration(
              labelStyle: Theme.of(context).textTheme.display1,
              hintText: 'Name',
              contentPadding: new EdgeInsets.all(5.0),
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 40.0,
            ),
            controller: controllerNickname,
            onChanged: (value) {
              nickname = value;
              _updateName(value);
            },
            focusNode: focusNodeNickname,
          ),
        ),
        margin: EdgeInsets.only(left: 30.0, right: 30.0),
      ),
    ]);
  }

  Future _updateName(String value) async {
    Firestore.instance.collection('users').document(id).updateData(
        {'nickname': nickname, 'photoUrl': photoUrl}).then((data) async {
      await prefs.setString('nickname', nickname);
    });
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });
    }
    uploadFile();
  }

  Future uploadFile() async {
    String fileName = id;
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          photoUrl = downloadUrl;
          Firestore.instance.collection('users').document(id).updateData(
              {'nickname': nickname, 'photoUrl': photoUrl}).then((data) async {
            await prefs.setString('nickname', nickname);
            await prefs.setString('photoUrl', photoUrl);
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'This file is not an image');
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'This file is not an image');
      }
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  Widget _getLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.red,
          elevation: UI.elevation,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Log out',
              style: TextStyle(
                fontSize: 30.0,
              ),
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            _getUserInfo(),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: _getLogoutButton(context),
              ),
            ),
          ]),
        ),
        color: UI.backgroundColor,
      ),
    );
  }
}
