import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:ohmnyomer/src/resources/oauth_provider.dart';
import 'package:ohmnyomer/src/resources/repository.dart';
import 'package:ohmnyomer/src/ui/loading_indicator_dialog.dart';
import 'package:rxdart/rxdart.dart';

class SigningValues {
  bool rememberMe;
  bool autoSignIn;
  String lastEmail;

  SigningValues(this.rememberMe, this.autoSignIn, this.lastEmail);
}

class SignBloc {
  final _repository = Repository();
  final _oauthProvider = OAuthProvider();

  final _resultSubject = PublishSubject<SignInResult>();
  final _valuesSubject = BehaviorSubject<SigningValues>();

  Stream<SignInResult> get resultSubject => _resultSubject.stream;
  Stream<SigningValues> get valuesSubject => _valuesSubject.stream;

  fetchValues() {
    var values = SigningValues(
      _repository.rememberMe,
      _repository.autoSignIn,
      _repository.signInEmail,
    );
    _valuesSubject.sink.add(values);
  }

  signUpWithEmail(BuildContext context,
      String name, email, password) {
    LoadingIndicatorDialog().show(context);
    _repository.signUpWithEmail(name, email, password)
        .then((value) {
      _resultSubject.sink.add(value);
    }).catchError((e) {
      _resultSubject.sink.addError(e);
    }).whenComplete(() => LoadingIndicatorDialog().dismiss());
  }

  signInWithEmail(BuildContext context,
      String email, password) {
    LoadingIndicatorDialog().show(context);
    _repository.signInWithEmail(email, password)
        .then((value) {
      _resultSubject.sink.add(value);
    }).catchError((e) {
      _resultSubject.sink.addError(e);
    }).whenComplete(() => LoadingIndicatorDialog().dismiss());
  }

  _signUpWithOAuthInfo(String name, email, Source oauthSrc, String oauthId, String photourl) =>
      _repository.signUpWithOAuthInfo(name, email,
          OAuthInfo(
            provider: OAuthInfo_Provider.valueOf(oauthSrc.index),
            id: oauthId,
          ), photourl)
      .then((value) => _resultSubject.sink.add(value));

  _signInWithOAuthInfo(String name, email, Source oauthSrc, String oauthId, String photourl) =>
      _repository.signInWithOAuthInfo(email,
          OAuthInfo(
            provider: OAuthInfo_Provider.valueOf(oauthSrc.index),
            id: oauthId,
          ))
          .then((value) => _resultSubject.sink.add(value))
          .catchError((e) => _signUpWithOAuthInfo(name, email, oauthSrc, oauthId, photourl),
          test: (e) => e is GrpcError && e.code == StatusCode.notFound);

  signInWithGoogle(BuildContext context) {
    LoadingIndicatorDialog().show(context);
    _oauthProvider.getGoogleIdentity()
        .then((value) => _signInWithOAuthInfo(value.name, value.email, value.source, value.id, value.photourl))
        .catchError((e) => _resultSubject.sink.addError(e))
        .whenComplete(() => LoadingIndicatorDialog().dismiss());
  }

  signInWithKakao(BuildContext context) {
    LoadingIndicatorDialog().show(context);
    _oauthProvider.getKakaoIdentity()
        .then((value) => _signInWithOAuthInfo(value.name, value.email, value.source, value.id, value.photourl))
        .catchError((e) => _resultSubject.sink.addError(e))
        .whenComplete(() => LoadingIndicatorDialog().dismiss());
  }

  setAutoSignIn(bool value) {
    _repository.autoSignIn = value;
    fetchValues();
  }
  setRememberMe(bool value) {
    _repository.rememberMe = value;
    fetchValues();
  }

  dispose() {
    _resultSubject.close();
  }
}