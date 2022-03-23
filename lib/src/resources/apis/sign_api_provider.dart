import 'package:dartnyom/protonyom_api_sign.pbgrpc.dart';
import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:ohmnyomer/src/constants.dart';

class Authorization {
  final Account _account;
  final String _token;

  Authorization.fromProto(SignReply reply)
      : _account = reply.account,
        _token = reply.token;

  Account get account => _account;
  String get token => _token;
}

class SignApiProvider {
  final ClientChannel channel;
  
  final CallOptions _callOptions = CallOptions(
    metadata: {'x-api-key': ohmnyomApiKey},
    compression: const GzipCodec(),
    timeout: const Duration(seconds: 5),
  );

  SignApiProvider()
      : channel = ClientChannel(
    ohmnyomServerHost,
    port: ohmnyomServerPort,
    options: ChannelOptions(
      codecRegistry: CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
      connectionTimeout: const Duration(seconds: 5),
    ),
  );

  SignApiClient _newClient() {
    return SignApiClient(
      channel,
      options: _callOptions,
    );
  }

  Future<Authorization> _signUp(SignUpRequest req) async {
    final client = _newClient();
    final resp = await client.signUp(req);
    return Authorization.fromProto(resp);
  }

  Future<Authorization> _signIn(SignInRequest req) async {
    final client = _newClient();
    final resp = await client.signIn(req);
    return Authorization.fromProto(resp);
  }

  Future<Authorization> signUpWithEmail(String name, email, password) {
    SignUpRequest req = SignUpRequest(
        name: name, email: email, password: password);
    return _signUp(req);
  }

  Future<Authorization> signUpWithOAuthInfo(String name, OAuthInfo info,
      String provider, String photourl) {
    SignUpRequest req = SignUpRequest(
      name: name, email: info.email, oauthinfo: info,
        oauthprovider: provider, photourl: photourl);
    return _signUp(req);
  }

  Future<Authorization> signInWithEmail(String email, password) {
    SignInRequest req = SignInRequest(
      emailcred: EmailCred(email: email, password: password));
    return _signIn(req);
  }

  Future<Authorization> signInWithOAuthInfo(OAuthInfo info, String provider) {
    SignInRequest req = SignInRequest(oauthinfo: info, oauthprovider: provider);
    return _signIn(req);
  }
}