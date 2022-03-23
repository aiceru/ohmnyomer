import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:ohmnyomer/src/resources/repository/repository.dart';
import 'package:ohmnyomer/src/resources/repository/repository_account_ext.dart';
import 'package:ohmnyomer/src/resources/repository/repository_pet_ext.dart';
import 'package:ohmnyomer/src/resources/repository/repository_feed_ext.dart';
import 'package:ohmnyomer/src/resources/repository/repository_sign_ext.dart';
import 'package:rxdart/rxdart.dart';

class FeedBloc {
  final Repository _repository = Repository();
  final _accountSubject = BehaviorSubject<Account?>();
  final _petSubject = PublishSubject<Pet?>();
  final _feedListSubject = PublishSubject<List<Feed>>();

  Stream<Account?> get accountSubject => _accountSubject.stream;
  Stream<Pet?> get petSubject => _petSubject.stream;
  Stream<List<Feed>> get feedListSubject => _feedListSubject.stream;

  dispose() {
    _accountSubject.close();
  }

  getAccount() {
    _accountSubject.sink.add(_repository.account);
  }

  Map<String, String>? fetchInvitedQueries() {
    var queries = _repository.invitedInfo;
    _repository.invitedInfo = null;
    return queries;
  }

  String? getPetId() {
    return _repository.petId;
  }

  setPetId(String? petId) {
    _repository.petId = petId;
  }

  fetchPet(String? petId) {
    if (petId == null || petId.isEmpty) {
      _petSubject.sink.add(null);
    } else {
      _repository.fetchPet(petId)
          .then((value) => _petSubject.sink.add(value))
          .catchError((e) => _petSubject.sink.addError(e));
    }
  }

  Future<Feed> addFeed(Feed feed) {
    return _repository.addFeed(feed);
  }

  fetchFeeds(String? petId, int startAfter, int limit) {
    if (petId == null || petId.isEmpty) {
      _feedListSubject.sink.add(<Feed>[]);
    } else {
      _repository.getFeeds(petId, startAfter, limit)
          .then((value) => _feedListSubject.sink.add(value))
          .catchError((e) => _feedListSubject.sink.addError(e));
    }
  }

  Future deleteFeed(String petId, String feedId) {
    return _repository.deleteFeed(petId, feedId);
  }

  Future<Feed> updateFeed(Feed feed) {
    return _repository.updateFeed(feed);
  }

  acceptInvite(String petId) {
    _repository.acceptInvite(petId)
        .then((value) => _accountSubject.sink.add(value))
        .catchError((e) => _accountSubject.sink.addError(e));
  }

  signOut() {
    _repository.signOut();
    // _accountSubject.sink.add(null);
  }
}
