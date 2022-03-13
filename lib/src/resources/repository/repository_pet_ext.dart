import 'dart:typed_data';

import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:ohmnyomer/src/resources/apis/pet_api_provider.dart';
import 'package:ohmnyomer/src/resources/repository/repository.dart';

extension RepositoryPetExt on Repository {
  Future<List<Pet>> addPet(Pet pet) async {
    PetListWithAccount resp = await petApiProvider.addPet(authToken!, pet);
    account = resp.account;
    return resp.petList;
  }

  Future<List<Pet>> updatePet(Pet pet) {
    return petApiProvider.updatePet(authToken!, pet);
  }

  Future<List<Pet>> getMyPetList() {
    if (account == null || account!.pets.isEmpty) {
      return Future.value([]);
    }
    return petApiProvider.getPetList(authToken!, account!.pets);
  }

  Future<List<Pet>> uploadPetProfile(String petId, String contentType, Uint8List bytes) {
    return petApiProvider.uploadPetProfile(authToken!, petId, contentType, bytes);
  }
}