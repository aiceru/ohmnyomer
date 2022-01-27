import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:ohmnyomer/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class FeedBloc {
  final _repository = Repository();
  final _accountSubject = PublishSubject<Account?>();
  final _petSubject = PublishSubject<Pet?>();

  Stream<Account?> get accountSubject => _accountSubject.stream;
  Stream<Pet?> get petSubject => _petSubject.stream;

  dispose() {
    _accountSubject.close();
  }

  fetchAccount() {
    Future<Account?> account = _repository.fetchAccount();
    account.then((value) => _accountSubject.sink.add(value));
  }

  signOut() {
    _repository.signOut();
    // _accountSubject.sink.add(null);
  }
}
