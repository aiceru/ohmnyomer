import 'dart:typed_data';
import 'package:dartnyom/protonyom_api_pet.pbgrpc.dart';
import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:ohmnyomer/src/resources/apis/api_provider.dart';
import 'package:ohmnyomer/src/resources/apis/auth_interceptor.dart';

class PetListWithAccount{
  final Account _account;
  final List<Pet> _petList;

  PetListWithAccount.fromAddPetReply(AddPetReply reply)
      : _account = reply.account,
        _petList = reply.pets;

  PetListWithAccount.fromDeletePetReply(DeletePetReply reply)
      : _account = reply.account,
        _petList = reply.pets;

  Account get account => _account;
  List<Pet> get petList => _petList;
}

class PetApiProvider{
  final ApiProvider _apiProvider;

  PetApiProvider()
  : _apiProvider = ApiProvider();

  PetApiClient _newClient() {
    return PetApiClient(
      _apiProvider.channel,
      options: _apiProvider.callOptions,
      interceptors: [AuthInterceptor()],
    );
  }

  PetApiClient _newClientWithAuth(String authToken) {
    return PetApiClient(
      _apiProvider.channel,
      options: _apiProvider.callOptions,
      interceptors: [AuthInterceptor.withToken(authToken)],
    );
  }

  Future<Map<String, Family>> getSupportedFamilies(String language) async {
    final client = _newClient();
    final resp = await client.getFamilies(
      GetFamiliesRequest()..language = language
    );
    return resp.families;
  }

  Future<PetListWithAccount> addPet(String authToken, Pet pet,
      String? contentType, Uint8List? bytes) async {
    final client = _newClientWithAuth(authToken);
    final resp = await client.addPet(
      AddPetRequest()
        ..pet = pet
        ..profileContentType = contentType ?? ''
        ..profilePhoto = bytes ?? Uint8List(0)
    );
    return PetListWithAccount.fromAddPetReply(resp);
  }

  Future<List<Pet>> updatePet(String authToken, Pet pet,
      String? contentType, Uint8List? bytes) async {
    final client = _newClientWithAuth(authToken);
    final resp = await client.updatePet(
      UpdatePetRequest()
        ..pet = pet
        ..profileContentType = contentType ?? ''
        ..profilePhoto = bytes ?? Uint8List(0)
    );
    return resp.pets;
  }

  Future<PetListWithAccount> deletePet(String authToken, String petId) async {
    final client = _newClientWithAuth(authToken);
    final resp = await client.deletePet(
      DeletePetRequest()..petId = petId
    );
    return PetListWithAccount.fromDeletePetReply(resp);
  }

  Future<List<Pet>> getPetList(String authToken, List<String> petIds) async {
    final client = _newClientWithAuth(authToken);
    final resp = await client.getPetList(
      GetPetListRequest(
        petIds: petIds,
      )
    );
    return resp.pets;
  }

  Future<Pet> getPet(String authToken, String petId) async {
    final client = _newClientWithAuth(authToken);
    final resp = await client.getPet(
      GetPetRequest()..petId = petId
    );
    return resp.pet;
  }
}