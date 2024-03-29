class Validator {
  String validateName(String value) {
    if (value.isEmpty)
      return "Enter a valid name";
    else
      return "";
  }

  String validateInput(String value) {
    if (value.trim().isEmpty)
      return "Enter a valid information";
    else
      return "";
  }

  String validatePassword(String value) {
    if (value.length < 3)
      return "Password must be than 2 characters";
    else
      return "";
  }

  String validateCode(String value) {
    if (value.length != 4)
      return "Verification must be 4 characters";
    else
      return "";
  }

  String validateMobile(String value) {
    final RegExp regex = RegExp(r'^(([(+]*[0-9]+[()+. -]*))');
    if (!regex.hasMatch(value)) return 'Enter a valid phone number.';
    return "";
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return "";
  }

  bool isValidEmail(String value) {
    return validateEmail(value).isEmpty;
  }

  bool isValidName(String value) {
    return validateName(value).isEmpty;
  }

  bool isValidPhoneNumber(String value) {
    return validateMobile(value).isEmpty;
  }

  bool isValidInput(String value) {
    return validateInput(value).isEmpty;
  }
}
