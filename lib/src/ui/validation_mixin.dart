import 'package:flutter/cupertino.dart';
import 'package:ohmnyomer/generated/l10n.dart';

class ValidationMixin {
  String? Function(String?) validateNameFunc(BuildContext context) {
    return (String? value) {
      if (value == null || value.length < 2) {
        return S.of(context).tooShort("2");
      }
      return null;
    };
  }

  String? Function(String?) validateEmailFunc(BuildContext context) {
    return (String? value) {
      if (value == null ||
          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
        return S.of(context).enterValidEmail;
      }
      return null;
    };
  }

  String? Function(String?) validatePasswordFunc(BuildContext context) {
    return (String? value) {
      if (value == null || value.length < 8) {
        return S.of(context).tooShort("8");
      }
      return null;
    };
  }
}