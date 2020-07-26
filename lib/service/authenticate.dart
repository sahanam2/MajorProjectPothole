import 'package:firebase_auth/firebase_auth.dart';
import 'package:potholedetection/model/user.dart';

class AuthService
{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFireBaseUser(FirebaseUser user)
  {
    return (user!=null)? User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged
      .map(_userFireBaseUser);
  }


  Future signUp(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFireBaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    } 
  }

   Future signIn(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    } 
  }


  //Sign in - guest
  Future signInGuest()  async
  {
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFireBaseUser(user);
    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }


}