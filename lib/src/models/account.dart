import 'package:flutter/cupertino.dart';

enum OAuthType {
  none,
  google,
  kakao,
  naver,
}

class Account {
  Account({
    required this.email,
    this.name,
    this.password,
    this.oAuthType = OAuthType.none,
    this.photoUrl,
  });

  String email;
  String? name;
  String? password;
  OAuthType oAuthType;
  String? photoUrl;

  // String toString() {
  //   String str = 'email: ' + email;
  //   if( name != null ) {
  //     str += '\nname: ' + name!;
  //   }
  //   if( password != null ) {
  //     str += '\npassword: ' + password!;
  //   }
  //   str += '\noAuthType: ' + oAuthType.toString();
  //   str += '\nph: ' + oAuthType.toString();
  //   return str;
  // }

  Account.fromJson(Map<String, dynamic> json)
  : email = json['email'],
  name = json['name'],
  password = json['password'],
  oAuthType = OAuthType.values.elementAt(json['oAuthType']),
  photoUrl = json['photoUrl'];

  Map<String, dynamic> toJson() => {
    'email': email,
    'name': name,
    'password': password,
    'oAuthType': oAuthType.index,
    'photoUrl': photoUrl,
  };

  bool isSignedIn() {
    return email != "";
  }

  reset() {
    email = ""; name = "";
    password = "";
    oAuthType = OAuthType.none;
  }
}
