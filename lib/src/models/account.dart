import 'package:flutter/cupertino.dart';

enum OAuthType {
  none,
  google,
  kakao,
  naver,
}

class Account {
  Account({
    required this.id,
    required this.email,
    this.name,
    this.password,
    this.photoUrl,
    this.oAuthType = OAuthType.none,
    this.oAuthID,
    required this.signedUp,
    this.pets,
  });

  String id;
  String email;
  String? name;
  String? password;
  String? photoUrl;
  OAuthType oAuthType;
  String? oAuthID;
  DateTime signedUp;
  List<String>? pets;
}
