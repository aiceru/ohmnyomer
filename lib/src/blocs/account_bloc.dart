import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:flutter/material.dart';
import 'package:ohmnyomer/src/resources/repository/repository.dart';
import 'package:ohmnyomer/src/resources/repository/repository_account_ext.dart';
import 'package:ohmnyomer/src/ui/widgets/loading_indicator_dialog.dart';
import 'package:rxdart/rxdart.dart';

class AccountBloc {
  final Repository _repository = Repository();
  final _accountSubject = BehaviorSubject<Account>();

  Stream<Account> get accountSubject => _accountSubject.stream;

  dispose() {
    _accountSubject.close();
  }

  fetchAccount() {
    _accountSubject.sink.add(_repository.account!);
  }

  updateName(BuildContext context, String name) {
    LoadingIndicatorDialog().show(context);
    _repository.updateName(name)
        .then((value) => _accountSubject.sink.add(value))
        .catchError((e) => _accountSubject.sink.addError(e))
        .whenComplete(() => LoadingIndicatorDialog().dismiss());
  }

  updatePassword(BuildContext context, String password) {
    LoadingIndicatorDialog().show(context);
    _repository.updatePassword(password)
        .then((value) => _accountSubject.sink.add(value))
        .catchError((e) => _accountSubject.sink.addError(e))
        .whenComplete(() => LoadingIndicatorDialog().dismiss());
  }
}
