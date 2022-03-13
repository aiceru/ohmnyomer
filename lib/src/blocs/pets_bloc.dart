import 'dart:io';
import 'dart:typed_data';

import 'package:dartnyom/protonyom_api_pet.pb.dart';
import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:mime/mime.dart';
import 'package:ohmnyomer/src/resources/repository/repository.dart';
import 'package:ohmnyomer/src/resources/repository/repository_pet_ext.dart';
import 'package:rxdart/rxdart.dart';

class PetsBloc {
  final Repository _repository = Repository();
  final _petListSubject = BehaviorSubject<List<Pet>>();
  final _accountSubject = BehaviorSubject<Account>();

  Stream<List<Pet>> get petListSubject => _petListSubject.stream;
  Stream<Account> get accountSubject => _accountSubject.stream;

  dispose() {
    _petListSubject.close();
  }

  getAccount() {
    _accountSubject.sink.add(_repository.account!);
  }

  fetchPetList() {
    _repository.getMyPetList()
        .then((value) => _petListSubject.sink.add(value))
        .catchError((e) => _petListSubject.sink.addError(e));
  }

  Map<String, Family>? getSupportedFamilies() {
    return _repository.familyMap;
  }

  addPet(Pet pet) {
    _repository.addPet(pet)
        .then((value) => _petListSubject.sink.add(value))
        .catchError((e) => _petListSubject.sink.addError(e));
  }

  updatePet(Pet pet) {
    _repository.updatePet(pet)
        .then((value) => _petListSubject.sink.add(value))
        .catchError((e) => _petListSubject.sink.addError(e));
  }

  uploadProfileImage(String petId, File image) {
    String? contentType = lookupMimeType(image.path);
    Uint8List bytes = image.readAsBytesSync();
    _repository.uploadPetProfile(petId, contentType ?? 'image/jpeg', bytes)
        .then((value) => _petListSubject.sink.add(value))
        .catchError((e) => _petListSubject.sink.addError(e));
  }
}
