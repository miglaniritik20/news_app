import 'package:flutter/material.dart';
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
          color: Colors.white,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(size: 150),
              SizedBox(height: 50),
              Container(
                width: 300.0,
                child: OutlineButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    highlightElevation: 0,
                    borderSide: BorderSide(color: Colors.grey),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1200px-Google_%22G%22_Logo.svg.png"), height: 35.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Sign in with Google',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                onPressed: () async{
                    dynamic result = await _auth.signInWithGoogle();
                    if(result!=null) {
                      setState(() {
                        _auth=result;
                        _networkImage = new NetworkImage(result.firebaseUser.photoURL);
                        name = result.firebaseUser.displayName;
                        email = result.firebaseUSer.email;
                      });
                      
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

