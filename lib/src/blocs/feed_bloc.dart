import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:ohmnyomer/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class FeedBloc {
  final _repository = Repository();
  final _accountSubject = BehaviorSubject<Account?>();
  final _petSubject = PublishSubject<Pet?>();

  Stream<Account?> get accountSubject => _accountSubject.stream;
  Stream<Pet?> get petSubject => _petSubject.stream;

  dispose() {
    _accountSubject.close();
  }

  fetchAccount() {
    _accountSubject.sink.add(_repository.account);
  }

  signOut() {
    _repository.signOut();
    // _accountSubject.sink.add(null);
  }
}
