import 'dart:io';
import 'dart:typed_data';

import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:mime/mime.dart';
import 'package:ohmnyomer/src/blocs/err_handler.dart';
import 'package:ohmnyomer/src/resources/repository/repository.dart';
import 'package:ohmnyomer/src/resources/repository/repository_account_ext.dart';
import 'package:ohmnyomer/src/resources/repository/repository_sign_ext.dart';
import 'package:rxdart/rxdart.dart';

class AccountBloc {
  final Repository _repository = Repository();
  final _accountSubject = BehaviorSubject<Account>();

  Stream<Account> get accountSubject => _accountSubject.stream;

  dispose() {
    _accountSubject.close();
  }

  getAccount() {
    _accountSubject.sink.add(_repository.account!);
  }

  fetchAccount(ErrorHandler? handler) {
    _repository.fetchAccount()
        .then((value) => _accountSubject.sink.add(value))
        .catchError((e) => handler?.onError(e));
  }

  updateName(String name, ErrorHandler? handler) {
    _repository.updateName(name)
        .then((value) => _accountSubject.sink.add(value))
        .catchError((e) => handler?.onError(e));
  }

  updatePassword(String password, ErrorHandler? handler) {
    _repository.updatePassword(password)
        .then((value) => _accountSubject.sink.add(value))
        .catchError((e) => handler?.onError(e));
  }

  uploadProfile(File? image, ErrorHandler? handler) {
    String? cType;
    Uint8List? content;
    if (image != null) {
      cType = lookupMimeType(image.path);
      content = image.readAsBytesSync();
    }

    _repository.uploadProfile(cType, content)
        .then((value) => _accountSubject.sink.add(value))
        .catchError((e) => handler?.onError(e));
  }

  Future deleteAccount() {
    return _repository.deleteAccount();
  }

  signOut() {
    _repository.signOut();
  }
}
