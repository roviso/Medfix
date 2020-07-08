// import 'package:flutter/material.dart';
// import '../models/patient.dart';
// import '../screens/profile.dart';

// Widget drawer(BuildContext context,Patient _patient ){
//   new Drawer(
//         child: new ListView(
//           children: <Widget>[
//             new UserAccountsDrawerHeader(
//               accountName: new Text("Welcome"),
//                 currentAccountPicture: new CircleAvatar(
//                   backgroundColor: Colors.white70,
//                   backgroundImage: NetworkImage(_patient.patient_img),                
                  
//                 ),
//                 accountEmail: Text(_patient.patient_name)
//             ),
//             new ListTile(
//               title: new Text("My Account"),
//               trailing: new Icon(Icons.account_box),
//               onTap: (){
//                 Navigator.of(context).pop();
//                 Navigator.of(context).push(new MaterialPageRoute(
//                   builder: (BuildContext context) =>
//                     new Profile(_patient.patient_email)
//                 ));
//               } ,
//             ),
//             new ListTile(
//               title: new Text("SignOut"),
//               trailing: new Icon(Icons.exit_to_app),
//               onTap: () => {},
//             ),
//             new ListTile(
//               title: new Text("back"),
//               trailing: new Icon(Icons.exit_to_app),
//               onTap: () => {},
//             ),
//           ],
//         ),
//       );

// }

