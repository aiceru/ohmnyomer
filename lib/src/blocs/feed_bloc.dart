import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:ohmnyomer/src/resources/repository/repository.dart';
import 'package:ohmnyomer/src/resources/repository/repository_pet_ext.dart';
import 'package:ohmnyomer/src/resources/repository/repository_sign_ext.dart';
import 'package:rxdart/rxdart.dart';

class FeedBloc {
  final Repository _repository = Repository();
  final _accountSubject = BehaviorSubject<Account?>();
  final _petFeedsSubject = PublishSubject<PetFeeds?>();

  Stream<Account?> get accountSubject => _accountSubject.stream;
  Stream<PetFeeds?> get petFeedsSubject => _petFeedsSubject.stream;

  dispose() {
    _accountSubject.close();
  }

  getAccount() {
    _accountSubject.sink.add(_repository.account);
  }

  String? getPetId() {
    return _repository.petId;
  }

  setPetId(String? petId) {
    _repository.petId = petId;
  }

  fetchPetWithFeeds(String petId) {
    _repository.fetchPetWithFeeds(petId)
        .then((value) => _petFeedsSubject.sink.add(value))
        .catchError((e) => _petFeedsSubject.sink.addError(e));
  }

  signOut() {
    _repository.signOut();
    // _accountSubject.sink.add(null);
  }
}
