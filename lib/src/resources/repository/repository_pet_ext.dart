import 'dart:typed_data';

import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:ohmnyomer/src/resources/apis/pet_api_provider.dart';
import 'package:ohmnyomer/src/resources/repository/repository.dart';

extension RepositoryPetExt on Repository {
  Future<List<Pet>> addPet(Pet pet, String? cType, Uint8List? content) async {
    PetListWithAccount resp = await petApiProvider.addPet(authToken!, pet, cType, content);
    account = resp.account;
    return resp.petList;
  }

  Future<List<Pet>> updatePet(Pet pet, String? cType, Uint8List? content) {
    return petApiProvider.updatePet(authToken!, pet, cType, content);
  }

  Future<List<Pet>> getMyPetList() {
    if (account == null || account!.pets.isEmpty) {
      return Future.value([]);
    }
    return petApiProvider.getPetList(authToken!, account!.pets);
  }
}