import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:ohmnyomer/src/blocs/err_handler.dart';
import 'package:ohmnyomer/src/resources/repository/repository.dart';
import 'package:ohmnyomer/src/resources/repository/repository_account_ext.dart';
import 'package:ohmnyomer/src/resources/repository/repository_pet_ext.dart';
import 'package:ohmnyomer/src/resources/repository/repository_feed_ext.dart';
import 'package:ohmnyomer/src/resources/repository/repository_sign_ext.dart';
import 'package:ohmnyomer/src/ui/timestamp.dart';
import 'package:rxdart/rxdart.dart';

class FeedBloc {
  final Repository _repository = Repository();
  final _accountSubject = BehaviorSubject<Account?>();
  final _petSubject = PublishSubject<Pet?>();
  final _feedListSubject = PublishSubject<List<Feed>>();

  Stream<Account?> get accountSubject => _accountSubject.stream;
  Stream<Pet?> get petSubject => _petSubject.stream;
  Stream<List<Feed>> get feedListSubject => _feedListSubject.stream;

  List<Feed> _feeds = List.empty(growable: true);
  String? _petId;

  dispose() {
    _accountSubject.close();
    _petSubject.close();
    _feedListSubject.close();
  }

  getAccount() {
    _accountSubject.sink.add(_repository.account);
  }

  Map<String, String>? getInvitedQueries() {
    var queries = _repository.invitedInfo;
    _repository.invitedInfo = null;
    return queries;
  }

  String? get petId => _petId;
  set petId(String? value) {
    if (_petId != value) {  // pet changed
      _feeds = List.empty(growable: true);
    }
    _petId = value;
    _repository.petId = value;
  }

  fetchPet(ErrorHandler? handler) {
    _petId = _repository.petId;
    if (_petId == null || _petId!.isEmpty) {
      _petSubject.sink.add(null);
    } else {
      _repository.fetchPet(_petId!)
          .then((value) => _petSubject.sink.add(value))
          .catchError((e) => handler?.onError(e));
    }
  }

  addFeed(Feed feed, ErrorHandler? handler) {
    feed.petId = _petId!;
    feed.feederId = _repository.account!.id;
    _repository.addFeed(feed).then((value) {
      int index = _feeds.indexWhere((f) => value.timestamp > f.timestamp);
      if (index >= 0) {
        _feeds.insert(index, value);
        _feedListSubject.sink.add(_feeds);
      }
    }).catchError((e) {
      handler?.onError(e);
    });
  }

  fetchFeeds(int limit, ErrorHandler? handler) async {
    if (_petId == null || _petId!.isEmpty) {
      _feedListSubject.sink.add(<Feed>[]);
    } else {
      try {
        List<Feed> got = await _repository.getFeeds(_petId!,
            _feeds.isEmpty
                ? DateTime.now().toUtc().toSecondsSinceEpoch()
                : _feeds.last.timestamp.toInt(),
            limit);
        _feeds.addAll(got);
        _feedListSubject.sink.add(_feeds);
      } catch(e) {
        handler?.onError(e);
      }
          // .then((value) => _feedListSubject.sink.add(value))
          // .catchError((e) => handler?.onError(e));
    }
  }

  deleteFeed(int index, ErrorHandler? handler) async {
    if (index < 0 || index >= _feeds.length) {
      return;
    }
    _repository.deleteFeed(_petId!, _feeds[index].id).then((value) {
      _feeds.removeAt(index);
      _feedListSubject.sink.add(_feeds);
    }).catchError((e) {
      handler?.onError(e);
    });
  }

  updateFeed(int index, ErrorHandler? handler) {
    if (index < 0 || index >= _feeds.length) {
      return;
    }
    _repository.updateFeed(_feeds[index]).then((value) {
      _feeds[index] = value;
      _feedListSubject.sink.add(_feeds);
    }).catchError((e) {
      handler?.onError(e);
    });
  }

  Future acceptInvite(String petId, ErrorHandler? handler) {
    return _repository.acceptInvite(petId);
  }

  signOut() {
    _repository.signOut();
  }
}
