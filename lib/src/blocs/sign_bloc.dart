import 'package:dartnyom/model.pb.dart';
import 'package:flutter/material.dart';
import 'package:ohmnyomer/src/resources/oauth_provider.dart';
import 'package:ohmnyomer/src/resources/repository.dart';
import 'package:ohmnyomer/src/ui/loading_indicator_dialog.dart';
import 'package:rxdart/rxdart.dart';

class SignBloc {
  final _repository = Repository();
  final _accountSubject = PublishSubject<Account>();
  final _oauthProvider = OAuthProvider();

  Stream<Account> get accountSubject => _accountSubject.stream;

  signUpWithEmail(BuildContext context,
      String name, email, password) {
    LoadingIndicatorDialog().show(context);
    Future<Account> account = _repository.signUpWithEmail(name, email, password);
    account.then((value) {
      _accountSubject.sink.add(value);
    }).catchError((e) {
      _accountSubject.sink.addError(e);
      return null;
    }).whenComplete(() => LoadingIndicatorDialog().dismiss());
  }

  signInWithEmail(BuildContext context,
      String email, password) {
    LoadingIndicatorDialog().show(context);
    Future<Account> account = _repository.signInWithEmail(email, password);
    account.then((value) {
      _accountSubject.sink.add(value);
    }).catchError((e) {
      _accountSubject.sink.addError(e);
      return null;
    }).whenComplete(() => LoadingIndicatorDialog().dismiss());
  }

  signInWithGoogle(BuildContext context) {
    LoadingIndicatorDialog().show(context);
    Future<OAuthIdentity?> identity = _oauthProvider.getGoogleIdentity();
    identity.then((value) {
      _repository.signInWithOAuthInfo(value!.email, OAuthInfo(
        provider: OAuthInfo_Provider.valueOf(value.source.index),
        id: value.id,
      ));
    }).catchError((e) {
      _accountSubject.sink.addError(e);
    }).whenComplete(() => LoadingIndicatorDialog().dismiss());
  }

  signInWithKakao(BuildContext context) {
    LoadingIndicatorDialog().show(context);
    Future<OAuthIdentity?> identity = _oauthProvider.getKakaoIdentity();
    identity.then((value) {
      _repository.signInWithOAuthInfo(value!.email, OAuthInfo(
        provider: OAuthInfo_Provider.valueOf(value.source.index),
        id: value.id,
      ));
    }).catchError((e) {
      _accountSubject.sink.addError(e);
    }).whenComplete(() => LoadingIndicatorDialog().dismiss());
}

  dispose() {
    _accountSubject.close();
  }
}