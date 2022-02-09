import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:ohmnyomer/src/resources/repository/repository.dart';

extension RepositoryPetExt on Repository {
  // Future<Map<String, String>> getSupportedFamilies() {
  //   return petApiProvider.getSupportedFamilies(authToken!, locale);
  // }
  //
  // Future<Map<String, String>> getSupportedSpecies(String family) {
  //   return petApiProvider.getSupportedSpecies(authToken!, locale, family);
  // }

  Future<List<Pet>> addPet(Pet pet) {
    return petApiProvider.addPet(authToken!, pet);
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
}