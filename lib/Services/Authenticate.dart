import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  final FirebaseAuth _auth =FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn =new GoogleSignIn();

  Stream<FirebaseUser> get user{
    return _auth.onAuthStateChanged;
  }

  //signin with google
  Future signInWithGoogle() async{
    try{
      final GoogleSignInAccount googleUser= await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      assert(user.email!=null);
      assert(user.displayName!=null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken()!=null);

      final FirebaseUser currentUser =await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      return user;
    }catch(e){
      print(e.toString());
      return null;
    }

  }

  //sign out
  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

}