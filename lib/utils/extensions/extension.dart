extension Validations on String {
  String? toValidEmail() {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern.toString());
    if (isEmpty) {
      return "Email Required";
    }
    if (!regExp.hasMatch(this)) {
      return "Invalid Email";
    }
    return null;
  }

  String? toValidPassword() {
    if (isEmpty) {
      return "Password Required";
    }
    if (length < 6) {
      return "Password is to short (minimum length is 6)";
    }
    return null;
  }

  String? toValidPhoneNumber() {
    if (isEmpty) {
      return "Phone Number Required";
    }
    // if(length > 11){
    //   return "Phone Number Not Valid";
    // }
    return null;
  }

  double? toDouble() {
    if (isNotEmpty) {
      return double.parse(trim());
    }

    return null;
  }

  String? toCheckNullEmpty() {
    if (isNotEmpty) {
      return this;
    }

    return "N/A";
  }
}
