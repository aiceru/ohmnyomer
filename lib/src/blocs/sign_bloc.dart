import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:ohmnyomer/src/blocs/err_handler.dart';
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

  checkSignInStatus(ErrorHandler? handler) {
    Account? account = _repository.account;
    if (account == null && _repository.autoSignIn) {
      _repository.signInWithCredential()
          .then((value) => _resultSubject.sink.add(value))
          .catchError((e) => handler?.onError(e));
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

  signUpWithEmail(String name, String email, String password, ErrorHandler? handler) {
    _repository.signUpWithEmail(name, email, password)
        .then((value) => _resultSubject.sink.add(value))
        .catchError((e) => handler?.onError(e));
  }

  signInWithEmail(String email, String password, ErrorHandler? handler) {
    _repository.signInWithEmail(email, password)
        .then((value) => _resultSubject.sink.add(value))
        .catchError((e) => handler?.onError(e));
  }

  _signUpWithOAuthInfo(String name, String email, String oauthId,
      String oauthProvider, String photourl, ErrorHandler? handler) {
    _repository.signUpWithOAuthInfo(name,
        OAuthInfo.create()
          ..email = email
          ..id = oauthId,
        oauthProvider, photourl)
        .then((value) => _resultSubject.sink.add(value))
        .catchError((e) => handler?.onError(e));
  }

  _signInWithOAuthInfo(String name, String email, String oauthId,
      String oauthProvider, String photourl, ErrorHandler? handler) {
    _repository.signInWithOAuthInfo(OAuthInfo.create()
      ..id = oauthId
      ..email = email,
        oauthProvider)
        .then((value) => _resultSubject.sink.add(value))
        .catchError((e) => _signUpWithOAuthInfo(name, email, oauthId, oauthProvider, photourl, handler),
        test: (e) => e is GrpcError && e.code == StatusCode.notFound)
        .catchError((e) => handler?.onError(e));
  }

  signInWithGoogle(ErrorHandler? handler) {
    _oauthProvider.getGoogleIdentity()
        .then((value) => _signInWithOAuthInfo(value.name, value.email, value.id, value.provider, value.photourl, handler))
        .catchError((e) => handler?.onError(e));
  }

  signInWithKakao(ErrorHandler? handler) {
    _oauthProvider.getKakaoIdentity()
        .then((value) => _signInWithOAuthInfo(value.name, value.email, value.id, value.provider, value.photourl, handler))
        .catchError((e) => handler?.onError(e));
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