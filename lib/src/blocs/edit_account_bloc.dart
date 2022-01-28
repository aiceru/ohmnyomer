import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:ohmnyomer/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class EditAccountBloc {
  final _repository = Repository();
  final _accountSubject = BehaviorSubject<Account>();

  Stream<Account> get accountSubject => _accountSubject.stream;

  dispose() {
    _accountSubject.close();
  }

  fetchAccount() {
    _accountSubject.sink.add(_repository.account!);
  }
}
