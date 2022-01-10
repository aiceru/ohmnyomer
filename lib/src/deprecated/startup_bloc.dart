import 'package:ohmnyom/src/models/account.dart';
import 'package:ohmnyom/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class StartupBloc {
  final _repository = Repository();
  final _accountSubject = PublishSubject<Account?>();

  Stream<Account?> get accountSubject => _accountSubject.stream;

  fetchAccount() {
    Future<Account?> account = _repository.fetchAccount();
    account.then((value) => _accountSubject.sink.add(value));
  }

  dispose() {
    _accountSubject.close();
  }
}