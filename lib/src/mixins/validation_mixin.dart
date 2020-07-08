class ValidationMixin{

  String validateName(String value){
    if (value.length < 4){
      return 'Name Too Short';
    }
    return null;        
  }

  String validateEmail(String value){
    if (!value.contains('@')){
      return 'Invalid Email Address';
    }

    return null;        
  }

  String validatePhoneNO (String value){
    if (value.length != 10){
      return 'Enter correct Mobile No';
      }

      return null;  
    }

  String validatePassword(String value){
    if (value.length < 5){
      return 'Password is too short';
    }  
    return null;
  }

  String validateAddress(String value){
    if (value.length < 3){
      return 'Invalid address';
    }
    return null;        
  }
}

