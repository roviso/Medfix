import 'package:flutter/material.dart';
import '../mixins/validation_mixin.dart';
import '../services/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/date_picker.dart';
import 'package:intl/intl.dart';


class LoginScreen extends StatefulWidget{
  LoginScreen({this.onSignedIn});

  final VoidCallback onSignedIn;

  createState(){
    return LoginScreenState();
  }
}

enum FormType{
  login,
  register
}


class LoginScreenState extends State<LoginScreen> with ValidationMixin{
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  static const Logo = 'assets/medfic.jpg';


  //   @override
  // void dispose() {
  //   // Clean up the controller when the widget is disposed.
  //   _emailController.dispose();
  //   _nameController.dispose();
  //   _passwordController.dispose();
  //   _addressController.dispose();
  //   super.dispose();
  // }

  bool _isLoading = false;
  FormType _formType = FormType.login;
  String _userId;

  Future<bool> _loginUser(String email, String password) async {
    final api = await Api.signInWithEmail(email: email, password: password,);
    if (api != null) {
      return true;
      
    } else {
      return false;
    }
  }

  Future<bool> _registerUser(String email, String password,String patient_name,String patient_address,
    int patient_contactNo, String patient_dob, String patient_sex, String img) async {
    final api = await Api.registerInWithEmail(email: email, password: password,patient_name: patient_name,patient_address: patient_address,patient_contactNo: patient_contactNo,patient_dob: patient_dob,patient_sex: patient_sex,img:img);
    if (api != null) {
      await Api.signInWithEmail(email: email, password: password,);
      return true;
    } else {
      return false;
    }
  }


  String name = '';
  String email = '';
  String password = '';
  String address = '';
  String sex = '';
  String img = 'https://firebasestorage.googleapis.com/v0/b/medfix-7d9f8.appspot.com/o/default_profilePic.jpg?alt=media&token=48bb50b4-4d8f-4881-bf2f-09e767583eb0';
  int phoneNo;
  String _day;
  String _month;
  String _year;
  // String dob = '$_day/$_month/$_year';




  
  Widget build(context) {
    return Center(child: SingleChildScrollView(
      child:     Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(20.0),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[

            Container(margin: EdgeInsets.only(top: 15.0)),
          ] + buildSubmitButtons(),

        ),
      
      ),
    ),
    ),);

  }




  List<Widget> buildSubmitButtons(){
    if(_formType == FormType.login){
    return[
      _build_logo(),
      SizedBox(height: 20),
      emailField(),
      passwordField(),
      submitButton(),
    new FlatButton(
      child: new Text('Create an Account? SignUp', style: new TextStyle(fontSize: 18.0)),
      onPressed: moveToregister,
    )];
    } else {
    return [

      nameField(),
      emailField(),
      passwordField(),
      phoneNoField(),
      addressField(),
      bodField(),
      sexField(),


      registerButton(),
    new FlatButton(
      child: new Text('Already have an Account? Login', style: new TextStyle(fontSize: 18.0)),
      onPressed: moveToLogin,
    )];

    }
  }

  void moveToregister(){
    formKey.currentState.reset();
    setState((){
      _formType = FormType.register;
    });

  }

  void moveToLogin(){
    formKey.currentState.reset();
    setState((){
      _formType = FormType.login;
    });
  }

  Widget _build_logo(){
    return Container(
     width: 150.0,
      height: 150.0,
      decoration: BoxDecoration(
      color: Colors.red,
      image: DecorationImage(
      image: AssetImage('assets/medfic.jpg'),
      fit: BoxFit.fill),
      borderRadius: BorderRadius.all(Radius.circular(75.0)),
      boxShadow: [
      BoxShadow(blurRadius: 7.0, color: Colors.black)
      ]));
  }

  Widget nameField(){
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _nameController,
      decoration: InputDecoration(        
        labelText: 'Full Name ',        
      ),
      validator: validateName,
      onSaved: (String value){
        name = value;
      },
    );
  }

  Widget emailField(){
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      decoration: InputDecoration(        
        labelText: 'Email Address',
        hintText: 'zxc@gmail.com',
      ),
      validator: validateEmail,

      onSaved: (String value){
        email = value;
      },
    );
  }



  Widget phoneNoField(){
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(        
        labelText: 'phone No:',
        
      ),

      validator: validatePhoneNO,
      
      onSaved: (String value){
        phoneNo = int.parse(value);
        
      },
    );    
  }

  Widget passwordField(){
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
        decoration: InputDecoration(        
          labelText: 'Password',
          hintText: 'Password',
        ),

      validator: validatePassword,
      
      onSaved: (String value){
        password = value;
      },
    );
  }


  Widget addressField(){
    return TextFormField(
      controller: _addressController,
      decoration: InputDecoration(        
        labelText: 'Address ',        
      ),
      validator: validateAddress,
      onSaved: (String value){
        address = value;
      },
    );
  }

  var _sex = ['Male','Female'];
  var _currentSex = 'Male';

  Widget sexField(){
    return DropdownButton<String>(
      items: _sex.map((String dropDownStringItem){
        return DropdownMenuItem<String>(
          value: dropDownStringItem,
          child: Text(dropDownStringItem),
        );
      }).toList(),

      onChanged: (String newValueSelected){
        setState(() {
          this._currentSex = newValueSelected;
          sex = newValueSelected;
                });                
      },
      value: _currentSex,      
      );
  }


  var year = ['1990','1991','1992','1993','1994','1995','1996','1997','1998','1999','2000','2001','2002','2003','2004','2005','2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019'];
  var month = ['1','2','3','4','5','6','7','8','9','10','11','12'];
  var day = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32'];
  var current_day = '1';
  var current_month = '1';
  var current_year = '2019';

  Widget bodField(){
    return Row(children: <Widget>[
      new DropdownButton<String>(
      items: day.map((String dropDownStringItem){
        return DropdownMenuItem<String>(
          value: dropDownStringItem,
          child: Text(dropDownStringItem),
        );
      }).toList(),

      onChanged: (String newValueSelected){
        setState(() {
          this.current_day = newValueSelected;
          _day = newValueSelected;
                });                
      },
      value: current_day,      
      ),

            new DropdownButton<String>(
      items: month.map((String dropDownStringItem){
        return DropdownMenuItem<String>(
          value: dropDownStringItem,
          child: Text(dropDownStringItem),
        );
      }).toList(),

      onChanged: (String newValueSelected){
        setState(() {
          this.current_month = newValueSelected;
          _month = newValueSelected;
                });                
      },
      value: current_month,      
      ),

            new DropdownButton<String>(
      items: year.map((String dropDownStringItem){
        return DropdownMenuItem<String>(
          value: dropDownStringItem,
          child: Text(dropDownStringItem),
        );
      }).toList(),

      onChanged: (String newValueSelected){
        setState(() {
          this.current_year = newValueSelected;
          _year = newValueSelected;
                });                
      },
      value: current_year,      
      ),

    ],);
  }


  
  Widget submitButton(){
    return RaisedButton( 
    color: Colors.red[100],
    child: Text('LOGIN'),
    onPressed: () async{
      if(formKey.currentState.validate())
      {
        formKey.currentState.save();
        setState(() => _isLoading = true);
          bool b = await _loginUser(
          _emailController.text, _passwordController.text);
          setState(() => _isLoading = false);
          if (b == true) {
            print('Login SuccessFul');
            widget.onSignedIn();            
            } else {
            pendingDialogue2(context);
            }
      }      
    },
    );
  }

    Future<Null> pendingDialogue2(BuildContext context){

    return showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return new AlertDialog(
          title: new Text('Please Try Again'),
          actions: <Widget>[
            new FlatButton(
              child: const Text('ok'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],

        );
      }
    );
  }

  Widget registerButton(){
    return RaisedButton( 
    color: Colors.red[100],
    child: Text('Register'),
    onPressed: () async{
      if(formKey.currentState.validate())
      {
        formKey.currentState.save();
        setState(() => _isLoading = true);
          bool b = await _registerUser(
          _emailController.text, _passwordController.text,name,address,phoneNo,'$_day/$_month/$_year',sex,img);
          setState(() => _isLoading = false);
          if (b == true) {
            widget.onSignedIn();
            } else {
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text("Wrong email or")));
            }
      }      
    },
    );

  }

  getUserId() async{
    var user = await FirebaseAuth.instance.currentUser();
    String userId = user.uid;
    print(userId);
    setState(() {
          _userId = userId;
        });
  }

 
  
}


class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText, style: valueStyle),
            new Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}









