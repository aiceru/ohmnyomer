import 'package:dartnyom/model.pb.dart';
import 'package:dartnyom/sign_api.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:ohmnyomer/src/constants.dart';

class SignApiProvider {
  final ClientChannel channel;
  final CallOptions _callOptions = CallOptions(
    compression: const GzipCodec(),
    // timeout: const Duration(seconds: 15),
  );

  SignApiProvider()
      : channel = ClientChannel(
    ohmnyomServerHost,
    port: ohmnyomServerPort,
    options: ChannelOptions(
      credentials: const ChannelCredentials.insecure(),
      codecRegistry: CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
    ),
  );

  Future<Account> _signUp(SignUpRequest req) async {
    final client = SignApiClient(channel);
    final resp = await client.signUp(req, options: _callOptions);
    return resp.account;
  }

  Future<Account> _signIn(SignInRequest req) async {
    final client = SignApiClient(channel);
    final resp = await client.signIn(req, options: _callOptions);
    return resp.account;
  }

  Future<Account> signUpWithEmail(String name, email, password) {
    SignUpRequest req = SignUpRequest(
        name: name, email: email, password: password);
    return _signUp(req);
  }

  Future<Account> signUpWithOAuthInfo(String name, email,
      OAuthInfo info, String photourl) {
    SignUpRequest req = SignUpRequest(
      name: name, email: email, oauthinfo: info, photourl: photourl);
    return _signUp(req);
  }

  Future<Account> signInWithEmail(String email, password) {
    SignInRequest req = SignInRequest(
      email: email, password: password);
    return _signIn(req);
  }

  Future<Account> signInWithOAuthInfo(String email, OAuthInfo info) {
    SignInRequest req = SignInRequest(
        email: email, oauthinfo: info);
    return _signIn(req);
  }
}