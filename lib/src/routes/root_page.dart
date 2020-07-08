import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../services/api.dart';

class RootPage extends StatefulWidget{
  createState(){
    return _RootPageState();
  }
}

enum AuthStatus{
  notSignedIn,
  signedIn
}

class _RootPageState extends State<RootPage>{
  AuthStatus authStatus = AuthStatus.notSignedIn;
  
  void initState(){
    super.initState();
    if (authStatus == AuthStatus.signedIn){
    Api.currentUser().then((userId){
      setState(() {
        authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;              
      });
    }
    );
    }
  }

  void _signedIn(){
    setState(() {
          authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut(){
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  Widget build(context){
    switch(authStatus){
      case AuthStatus.notSignedIn:
        return new LoginScreen(
          onSignedIn: _signedIn,
        );
      case AuthStatus.signedIn:
        return new HomeScreen(
          onSignedOut: _signedOut,          
        );
    }
  }
}