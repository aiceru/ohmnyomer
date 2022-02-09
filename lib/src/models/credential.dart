import 'dart:convert';

import 'package:dartnyom/protonyom_models.pb.dart';

class Credential {
  String email;
  String? password;
  String? oauthProvider;
  OAuthInfo? oauthinfo;

  Credential(this.email, {this.password, this.oauthProvider, this.oauthinfo});

  Credential.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        password = json['password'],
        oauthProvider = json['oauth_provider'],
        oauthinfo = OAuthInfo.fromJson(json['oauth_info']);

  Map<String, dynamic> toJson() {
    var info = oauthinfo?.writeToJson();
    return {
      'email': email,
      'password': password,
      'oauth_provider': oauthProvider,
      'oauth_info': info,
    };
  }
}