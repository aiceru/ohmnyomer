import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:ohmnyomer/src/resources/repository/repository.dart';
import 'package:ohmnyomer/src/resources/repository/repository_sign_ext.dart';
import 'package:rxdart/rxdart.dart';

class FeedBloc {
  final Repository _repository = Repository();
  final _accountSubject = BehaviorSubject<Account?>();
  final _petSubject = PublishSubject<Pet?>();

  Stream<Account?> get accountSubject => _accountSubject.stream;
  Stream<Pet?> get petSubject => _petSubject.stream;

  dispose() {
    _accountSubject.close();
  }

  getAccount() {
    _accountSubject.sink.add(_repository.account);
  }

  signOut() {
    _repository.signOut();
    // _accountSubject.sink.add(null);
  }
}
