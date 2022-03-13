import 'dart:typed_data';

import 'package:dartnyom/protonyom_api_pet.pbgrpc.dart';
import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:grpc/grpc.dart';
import 'package:ohmnyomer/src/constants.dart';
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
  final ClientChannel channel;
  final CallOptions _callOptions = CallOptions(
    compression: const GzipCodec(),
    // timeout: const Duration(seconds: 15),
  );

  PetApiProvider()
      : channel = ClientChannel(
    ohmnyomServerHost,
    port: ohmnyomServerPort,
    options: ChannelOptions(
      credentials: const ChannelCredentials.insecure(),
      codecRegistry: CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
    ),
  );

  PetApiClient _newClient() {
    return PetApiClient(
      channel,
      options: _callOptions,
    );
  }

  PetApiClient _newClientWithAuth(String authToken) {
    return PetApiClient(
      channel,
      options: _callOptions,
      interceptors: [AuthInterceptor(authToken)],
    );
  }

  Future<Map<String, Family>> getSupportedFamilies(String language) async {
    final client = _newClient();
    final resp = await client.getFamilies(
      GetFamiliesRequest()..language = language
    );
    return resp.families;
  }

  Future<PetListWithAccount> addPet(String authToken, Pet pet) async {
    final client = _newClientWithAuth(authToken);
    final resp = await client.addPet(
      AddPetRequest()..pet = pet
    );
    return PetListWithAccount.fromAddPetReply(resp);
  }

  Future<List<Pet>> updatePet(String authToken, Pet pet) async {
    final client = _newClientWithAuth(authToken);
    final resp = await client.updatePet(
      UpdatePetRequest()..pet = pet
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

  Future<List<Pet>> uploadPetProfile(String authToken, String petId,
      String contentType, Uint8List bytes) async {
    final client = _newClientWithAuth(authToken);
    final resp = await client.uploadPetProfile(
      UploadPetProfileRequest(
        petId: petId,
        contentType: contentType,
        content: bytes,
      )
    );
    return resp.pets;
  }
}