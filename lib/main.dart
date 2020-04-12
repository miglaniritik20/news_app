import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/HomePages/HomePage.dart';
import 'package:newsapp/HomePages/LoginHome.dart';
import 'package:provider/provider.dart';
import 'Services/Authenticate.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value: AuthService().user,
      child: new MaterialApp(
        title: 'News App',
        home: new Wrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user=Provider.of<FirebaseUser>(context);
    if(user==null){
      return LoginHomePage();
    }else{
      return HomePage();
    }

  }
}
