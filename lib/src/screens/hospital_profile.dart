import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/top_layout.dart';

class HospitalProfile extends StatelessWidget{


  Widget build(context){
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var screenWidth = MediaQuery.of(context).size.width;
    const BACKGROUND_IMAGE = 'assets/search.jpg';


    var diagonalBackground = new DiagonallyColoredImage(
      new Image.asset(
        BACKGROUND_IMAGE,
        width: screenWidth,
        height: 280.0,
        fit: BoxFit.cover,
      ),
      color: const Color(0xBB42A5F5),
    );

    var avatar = new Center(
      child: new CircleAvatar(
        backgroundImage: new NetworkImage('patient_img'),
        radius: 75.0,
      ),

    );


    return new Scaffold(
      body: new Container(
         child:  new Stack(
      children: [
        diagonalBackground,
        new Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 1.4,
          child: new Column(
            children: [
              avatar,
            ],
          ),
        ),
        new Positioned(
          top: 26.0,
          left: 4.0,
          child: new BackButton(color: Colors.white),
        ),
      ],
    )));    
  }
}
//     return new Stack(
//       children: <Widget>[
//         ClipPath(
//           child: Container(color: Colors.black.withOpacity(0.8)),
//           clipper: getClipper(),
//         ),
//         Positioned(
//             width: 350.0,
//             top: MediaQuery.of(context).size.height / 5,
//             child: Column(
//               children: <Widget>[
//                 Container(
//                     width: 150.0,
//                     height: 150.0,
//                     decoration: BoxDecoration(
//                         color: Colors.red,
//                         image: DecorationImage(
//                             image: NetworkImage(
//                                 'patient_img'),
//                             fit: BoxFit.cover),
//                         borderRadius: BorderRadius.all(Radius.circular(75.0)),
//                         boxShadow: [
//                           BoxShadow(blurRadius: 7.0, color: Colors.black)
//                         ])),
//                 SizedBox(height: 90.0),
//                 Text(
//                   'patient_name',
//                   style: TextStyle(
//                       fontSize: 30.0,
//                       fontWeight: FontWeight.bold,
//                       ),
//                 ),
//                 SizedBox(height: 15.0),
//                 Text(
//                   'patient_email',
//                   style: TextStyle(
//                       fontSize: 17.0,
//                       fontStyle: FontStyle.italic,
//                       ),
//                 ),
//                 SizedBox(height: 25.0),
//                 Container(
//                     height: 30.0,
//                     width: 95.0,
//                     child: Material(
//                       borderRadius: BorderRadius.circular(20.0),
//                       shadowColor: Colors.greenAccent,
//                       color: Colors.green,
//                       elevation: 7.0,
//                       child: GestureDetector(
//                         onTap: () {},
//                         child: Center(
//                           child: Text(
//                             'Edit Name',
//                             style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
//                           ),
//                         ),
//                       ),
//                     )),
//                     SizedBox(height: 25.0),
//                 Container(
//                     height: 30.0,
//                     width: 95.0,
//                     child: Material(
//                       borderRadius: BorderRadius.circular(20.0),
//                       shadowColor: Colors.redAccent,
//                       color: Colors.red,
//                       elevation: 7.0,
//                       child: GestureDetector(
//                         onTap: () {},
//                         child: Center(
//                           child: Text(
//                             'Log out',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ))
//               ],
//             ))
//       ],
//     );
  

//   }
// }



//      return new Container(

//           child: Material(
//             elevation: 7.0,
//             borderRadius: BorderRadius.circular(7.0),
//             child: Container(
              
//               padding: EdgeInsets.all(10.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text('My Profile', style: TextStyle(fontSize: 17.0), textAlign: TextAlign.center,),
//                   SizedBox(height: 10.0,),
//                   Container(
//                     height: 0.5,
//                     width: double.infinity,
//                     color: Colors.blue,),
//                   SizedBox(height: 15.0),
//                   Text('hellow'),
//                   SizedBox(height: 45.0,),
//                   Row(children: <Widget>[
//                     Row(children: <Widget>[
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Container(
//                             height: 50.0,
//                             width: 50.0,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(25.0),
//                               image: DecorationImage(
//                                 image: NetworkImage(
//                                   patient_img),
//                                   fit: BoxFit.cover

//                                 )
//                               )
//                             ),
//                           SizedBox(height: 5.0,),
//                             Text(
//                               patient_name,
//                               style: TextStyle(fontSize: 14.0),
//                             ),
//                             Text(
//                               patient_email,
//                               style: TextStyle(fontSize: 14.0),
//                             )

//                       ],),
//                       SizedBox(width: 25.0,),
//                       Text(
//                         patient_age,                        
//                       )

//                     ],)
//                   ],)

//                 ],
//               ),
            
//             ),
//           ),
//           );
        
    
//   }
// }





  
//   class getClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = new Path();

//     path.lineTo(0.0, size.height / 1.9);
//     path.lineTo(size.width + 125, 0.0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     // TODO: implement shouldReclip
//     return true;
//   }
// }





