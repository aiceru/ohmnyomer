import 'package:ohmnyomer/src/blocs/signin_bloc.dart';
import 'package:ohmnyomer/src/models/account.dart';
import 'package:ohmnyomer/src/models/credential.dart';
import 'package:ohmnyomer/src/resources/credential_provider.dart';
import 'package:ohmnyomer/src/resources/signin_provider.dart';

class Repository {
  static final Repository _repository = Repository._createInstance();
  Repository._createInstance();

  factory Repository() {
    return _repository;
  }

  Account? _account;
  final credentialProvider = CredentialProvider();
  final signInProvider = SignInProvider();

  Future<Account?> fetchAccount() async {
    if (_account != null) {
      return Future<Account?>.value(_account);
    }

    Credential? cred = await credentialProvider.loadCredential();
    if (cred != null) {
      _account = await signInProvider.signIn(cred);
    }

    return _account;
  }

  Future<SignInResult> signIn(Credential cred) async {
    _account = await signInProvider.signIn(cred);
    if (_account != null) {
      credentialProvider.saveCredential(Credential.fromAccount(_account!));
      return SignInResult.success;
    }
    return SignInResult.fail;
  }

  Future<SignInResult> signInWithGoogle() async {
    _account = await signInProvider.signInWithGoogle();
    if (_account != null) {
      credentialProvider.saveCredential(Credential.fromAccount(_account!));
      return SignInResult.success;
    }
    return SignInResult.fail;
  }

  Future<SignInResult> signInWithKakao() async {
    _account = await signInProvider.signInWithKakao();
    if (_account != null) {
      credentialProvider.saveCredential(Credential.fromAccount(_account!));
      return SignInResult.success;
    }
    return SignInResult.fail;
  }

  Account? signOut() {
    if (_account != null) {
      signInProvider.signOut(_account!);
      _account = null;
    }
    return _account;
  }
}