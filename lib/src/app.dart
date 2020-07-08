import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'routes/root_page.dart';
import 'screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class App extends StatelessWidget{

  Widget build(context){
    return MaterialApp(
      title: 'MedFix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.pinkAccent,
      ),
      home: Scaffold(
        body: RootPage(),

      ),
     // onGenerateRoute: routes,
      //  routes: <String, WidgetBuilder>{
      //    "/search": (context) => new Profile("My Profile"),
      //  }, 
    );
  }
}

// Route routes(RouteSettings settings){
//   switch(settings.name){
//     case '/':
//     return MaterialPageRoute(
//       builder: (context){
//         return RootPage();
//     },);
//     break;
//     case '/search':
//     return MaterialPageRoute(
//       builder: (context){
//         print('routing');
//         return Profile();
//     },);
//     break;
//   }
  
//}