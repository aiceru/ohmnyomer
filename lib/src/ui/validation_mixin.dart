class ValidationMixin {
  String? validateName(String? value) {
    if (value == null || value.length < 3) {
      return 'too short';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null ||
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
      return 'Enter valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 8) {
      return 'too short';
    }
    return null;
  }
}