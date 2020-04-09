import 'package:flutter/material.dart';
import 'package:newsapp/HomePages/HomePage.dart';
import 'package:newsapp/Services/Authenticate.dart';

class LoginHomePage extends StatefulWidget {
  LoginHomePage({Key key}) : super(key: key);

  @override
  _LoginHomePageState createState() => _LoginHomePageState();
}

class _LoginHomePageState extends State<LoginHomePage> {
  NetworkImage _networkImage;
  String error='';
  String name ='';
  String email= '';
  AuthService _auth= new AuthService();
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          color: Colors.blueAccent,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            
              Container(
                width: 300.0,
                child: RaisedButton(
                child: Text('Google'),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                elevation: 8.0,
                color: Colors.red,
                
                onPressed: () async{
                    dynamic result = _auth.signInWithGoogle();
                    if(result!=null) {
                      setState(() {
                        _auth=result;
                        _networkImage = new NetworkImage(result.firebaseUser.photoURL);
                        name = result.firebaseUser.displayName;
                        email = result.firebaseUSer.email;
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                    }

                }),
              ),
            
            ],
          )
        )
      ],
    );
  }
}

