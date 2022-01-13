import 'package:ohmnyomer/src/models/account.dart';

class Credential {
  Credential({
    this.email, this.password, this.oAuthType = OAuthType.none, this.oAuthID});

  String? email;
  String? password;
  OAuthType oAuthType;
  String? oAuthID;

  Credential.fromAccount(Account account)
      : email = account.email,
        password = account.password,
        oAuthType = account.oAuthType,
        oAuthID = account.oAuthID;

  Credential.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        password = json['password'],
        oAuthType = OAuthType.values.elementAt(json['oauthtype']),
        oAuthID = json['oauthid'];

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'oauthtype': oAuthType.index,
    'oauthid': oAuthID,
  };
}
