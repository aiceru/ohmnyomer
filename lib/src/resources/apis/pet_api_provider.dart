import 'package:dartnyom/protonyom_api_pet.pbgrpc.dart';
import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:grpc/grpc.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:ohmnyomer/src/resources/apis/auth_interceptor.dart';

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

  Future<List<Pet>> addPet(String authToken, Pet pet) async {
    final client = _newClientWithAuth(authToken);
    final resp = await client.addPet(
      AddPetRequest()..pet = pet
    );
    return resp.pets;
  }

  Future<List<Pet>> updatePet(String authToken, Pet pet) async {
    final client = _newClientWithAuth(authToken);
    final resp = await client.updatePet(
      UpdatePetRequest()..pet = pet
    );
    return resp.pets;
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
}