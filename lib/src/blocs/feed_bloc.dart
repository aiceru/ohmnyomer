import 'package:ohmnyom/src/models/account.dart';
import 'package:ohmnyom/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class FeedBloc {
  final _repository = Repository();
  final _accountSubject = PublishSubject<Account?>();

  Stream<Account?> get accountSubject => _accountSubject.stream;

  dispose() {
    _accountSubject.close();
  }

  fetchAccount() {
    Future<Account?> account = _repository.fetchAccount();
    account.then((value) => _accountSubject.sink.add(value));
  }

  signOut() {
    _accountSubject.sink.add(_repository.signOut());
  }
}