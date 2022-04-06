import 'package:dartnyom/protonyom_api_sign.pbgrpc.dart';
import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:ohmnyomer/src/resources/apis/api_provider.dart';
import 'package:ohmnyomer/src/resources/apis/auth_interceptor.dart';

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
  final ApiProvider _apiProvider;

  SignApiProvider()
  : _apiProvider = ApiProvider();

  SignApiClient _newClient() {
    return SignApiClient(
      _apiProvider.channel,
      options: _apiProvider.callOptions,
      interceptors: [AuthInterceptor()],
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