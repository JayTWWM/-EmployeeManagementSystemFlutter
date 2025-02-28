import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'AdminHome.dart';

class MyLoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  @override
  void initState() {
    super.initState();
    getDriversList().then((results) {
      setState(() {
        querySnapshot = results;
      });
    });
  }

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 17.5);

  String email;
  String password;
  bool isAdmin;
  AuthResult result;
  FirebaseUser user;

  QuerySnapshot querySnapshot;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Widget build(BuildContext context) {
    final emailField = Container(
        margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: TextField(
          onChanged: (text) {
            email = text;
          },
          obscureText: false,
          style: style,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(width: 10),
            ),
            fillColor: Colors.deepOrange,
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
          ),
        ));
    final passwordField = Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: TextField(
        onChanged: (text) {
          password = text;
        },
        obscureText: true,
        style: style,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 10),
          ),
          fillColor: Colors.deepOrange,
          labelText: 'Password',
          prefixIcon: Icon(Icons.lock),
        ),
      ),
    );
    return Scaffold(
        appBar: AppBar(
          title: Text("Login Page"),
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.fromLTRB(5, 50, 5, 0),
                child: Column(children: <Widget>[
                  Image.asset(
                      "assets/icon/logo.jpg",
                      width: 360,
                      height: 360),
                  emailField,
                  passwordField,
                  new RaisedButton(
                    shape: StadiumBorder(),
                    color: Colors.deepOrangeAccent,
                    child: Text("Login"),
                    onPressed: () async {
                      getUser();
                      try {
                        result = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        setState(() {
                          user = result.user;
                          if (user != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyAdminHomePage()));
                          }
                        });
                      } catch (e) {
                        print('JAY' + e.toString());
                        Fluttertoast.showToast(
                            msg: 'Login failed due to: ' + e.toString(),
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIos: 3,
                            backgroundColor: Colors.red[100],
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                  ),
                ]))));
  }

  getDriversList() async {
    return await Firestore.instance.collection('User').getDocuments();
  }

  getUser() {
    for (final element in querySnapshot.documents) {
      if (element.data["Email"] == email) {
        setState(() {
          isAdmin = element.data["IsAdmin"];
        });
      }
    }
  }
}
