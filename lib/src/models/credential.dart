import 'package:dartnyom/model.pb.dart';

class Credential {
  String email;
  String? password;
  OAuthInfo? oauthinfo;

  Credential(this.email, {this.password, this.oauthinfo});

  Credential.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        password = json['password'],
        oauthinfo = OAuthInfo(
          // provider: OAuthInfo_Provider.values.elementAt(json['oauth_provider']),
          provider: OAuthInfo_Provider.valueOf(json['oauth_provider']),
          id: json['oauth_id'],
        );

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'oauth_provider': oauthinfo?.provider.value,
    'oauth_id': oauthinfo?.id,
  };
}