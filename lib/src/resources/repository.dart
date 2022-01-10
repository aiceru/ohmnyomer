import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ohmnyom/src/blocs/signin_bloc.dart';
import 'package:ohmnyom/src/resources/signin_provider.dart';
import 'package:ohmnyom/src/ui/signin_route.dart';
import '../models/account.dart';
import '../resources/account_provider.dart';

class Repository {
  static final Repository _repository = Repository._createInstance();
  Repository._createInstance();

  factory Repository() {
    return _repository;
  }

  Account? _account;
  final accountProvider = AccountProvider();
  final signInProvider = SignInProvider();

  Future<Account?> fetchAccount() {
    if (_account != null) {
      return Future<Account?>.value(_account);
    }
    Future<Account?> future = accountProvider.fetchAccount();
    future.then((value) => _account = value );
    return future;
  }

  Future<SignInResult> signInWithGoogle() async {
    _account = await signInProvider.signInWithGoogle();
    if (_account!.isSignedIn()) {
      return SignInResult.success;
    }
    return SignInResult.fail;
  }

  Future<SignInResult> signInWithKakao() async {
    _account = await signInProvider.signInWithKakao();
    if (_account!.isSignedIn()) {
      return SignInResult.success;
    }
    return SignInResult.fail;
  }

  Account signOut() {
    if (_account != null) {
      signInProvider.signOut(_account!);
      _account!.reset();
    }
    return Account(email: "");
  }
}