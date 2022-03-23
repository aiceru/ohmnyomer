import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:ohmnyomer/src/resources/oauth_provider.dart';
import 'package:ohmnyomer/src/resources/repository/repository.dart';
import 'package:ohmnyomer/src/resources/repository/repository_sign_ext.dart';
import 'package:ohmnyomer/src/ui/widgets/loading_indicator_dialog.dart';
import 'package:rxdart/rxdart.dart';

class SharedPrefValues {
  bool rememberMe;
  bool autoSignIn;
  String lastEmail;

  SharedPrefValues(this.rememberMe, this.autoSignIn, this.lastEmail);
}

class SignBloc {
  final Repository _repository = Repository();
  final _oauthProvider = OAuthProvider();

  final _resultSubject = PublishSubject<SignInResult>();
  final _valuesSubject = BehaviorSubject<SharedPrefValues>();
  final _formValidationSubject = PublishSubject<bool>();

  Stream<SignInResult> get resultSubject => _resultSubject.stream;
  Stream<SharedPrefValues> get valuesSubject => _valuesSubject.stream;
  Stream<bool> get formValidationSubject => _formValidationSubject.stream;

  checkSignInStatus() {
    Account? account = _repository.account;
    if (account == null && _repository.autoSignIn) {
      _repository.signInWithCredential()
          .then((value) => _resultSubject.sink.add(value))
          .catchError((e) => _resultSubject.sink.addError(e));
    }
  }

  getSharedPrefValues() {
    var values = SharedPrefValues(
      _repository.rememberMe,
      _repository.autoSignIn,
      _repository.signInEmail,
    );
    _valuesSubject.sink.add(values);
  }

  signUpWithEmail(String name, String email, String password) {
    _repository.signUpWithEmail(name, email, password)
        .then((value) {
      _resultSubject.sink.add(value);
    }).catchError((e) {
      _resultSubject.sink.addError(e);
    });
  }

  signInWithEmail(String email, String password) {
    _repository.signInWithEmail(email, password)
        .then((value) {
      _resultSubject.sink.add(value);
    }).catchError((e) {
      _resultSubject.sink.addError(e);
    });
  }

  _signUpWithOAuthInfo(String name, String email, String oauthId,
      String oauthProvider, String photourl) {
    _repository.signUpWithOAuthInfo(name,
        OAuthInfo.create()
          ..email = email
          ..id = oauthId,
        oauthProvider, photourl)
        .then((value) => _resultSubject.sink.add(value))
        .catchError((e) => _resultSubject.sink.addError(e));
  }

  _signInWithOAuthInfo(String name, String email, String oauthId,
      String oauthProvider, String photourl) {
    _repository.signInWithOAuthInfo(OAuthInfo.create()
      ..id = oauthId
      ..email = email,
        oauthProvider)
        .then((value) => _resultSubject.sink.add(value))
        .catchError((e) => _signUpWithOAuthInfo(name, email, oauthId, oauthProvider, photourl),
        test: (e) => e is GrpcError && e.code == StatusCode.notFound)
        .catchError((e) => _resultSubject.sink.addError(e));
  }

  signInWithGoogle() {
    _oauthProvider.getGoogleIdentity()
        .then((value) => _signInWithOAuthInfo(value.name, value.email, value.id, value.provider, value.photourl))
        .catchError((e) => _resultSubject.sink.addError(e));
  }

  signInWithKakao() {
    _oauthProvider.getKakaoIdentity()
        .then((value) => _signInWithOAuthInfo(value.name, value.email, value.id, value.provider, value.photourl))
        .catchError((e) => _resultSubject.sink.addError(e));
  }

  validate(GlobalKey<FormState> key) {
    if (key.currentState != null) {
      _formValidationSubject.sink.add(key.currentState!.validate());
    }
  }

  setAutoSignIn(bool value) {
    _repository.autoSignIn = value;
    getSharedPrefValues();
  }
  setRememberMe(bool value) {
    _repository.rememberMe = value;
    getSharedPrefValues();
  }

  dispose() {
    _resultSubject.close();
  }
}