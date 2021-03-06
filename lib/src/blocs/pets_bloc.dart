import 'dart:io';
import 'dart:typed_data';

import 'package:dartnyom/protonyom_api_pet.pb.dart';
import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:mime/mime.dart';
import 'package:ohmnyomer/src/blocs/err_handler.dart';
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
    _accountSubject.close();
  }

  getAccount() {
    _accountSubject.sink.add(_repository.account!);
  }

  fetchPetList(ErrorHandler? handler) {
    _repository.getMyPetList()
        .then((value) => _petListSubject.sink.add(value))
        .catchError((e) => handler?.onError(e));
  }

  Map<String, Family>? getSupportedFamilies() {
    return _repository.familyMap;
  }

  addPet(Pet pet, File? image, ErrorHandler? handler) {
    String? cType;
    Uint8List? content;
    if (image != null) {
      cType = lookupMimeType(image.path);
      content = image.readAsBytesSync();
    }

    _repository.addPet(pet, cType, content)
        .then((value) => _petListSubject.sink.add(value))
        .catchError((e) => handler?.onError(e));
  }

  updatePet(Pet pet, File? image, ErrorHandler? handler) {
    String? cType;
    Uint8List? content;
    if (image != null) {
      cType = lookupMimeType(image.path);
      content = image.readAsBytesSync();
    }

    _repository.updatePet(pet, cType, content)
        .then((value) => _petListSubject.sink.add(value))
        .catchError((e) => handler?.onError(e));
  }

  deletePet(Pet pet, ErrorHandler? handler) {
    _repository.deletePet(pet.id)
        .then((value) => _petListSubject.sink.add(value))
        .catchError((e) => handler?.onError(e));
  }
}
