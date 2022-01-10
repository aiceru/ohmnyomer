import 'package:ohmnyom/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

enum SignInResult {
  success,
  fail,
}

class SignInBloc {
  final _repository = Repository();
  final _resultSubject = PublishSubject<SignInResult>();

  Stream<SignInResult> get resultSubject => _resultSubject.stream;

  signInWithGoogle() {
    Future<SignInResult> result = _repository.signInWithGoogle();
    result.then((value) => _resultSubject.sink.add(value));
  }

  signInWithKakao() {
    Future<SignInResult> result = _repository.signInWithKakao();
    result.then((value) => _resultSubject.sink.add(value));
  }

  dispose() {
    _resultSubject.close();
  }
}