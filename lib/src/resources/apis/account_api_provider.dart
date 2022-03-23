import 'package:dartnyom/protonyom_api_account.pbgrpc.dart';
import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:grpc/grpc.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:ohmnyomer/src/resources/apis/auth_interceptor.dart';

class AccountApiProvider {
  final ClientChannel channel;
  final CallOptions _callOptions = CallOptions(
    compression: const GzipCodec(),
    // timeout: const Duration(seconds: 15),
  );

  AccountApiProvider()
      : channel = ClientChannel(
    ohmnyomServerHost,
    port: ohmnyomServerPort,
    options: ChannelOptions(
      credentials: const ChannelCredentials.insecure(),
      codecRegistry: CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
    ),
  );

  AccountApiClient _newClient(String authToken) {
    return AccountApiClient(
      channel,
      options: _callOptions,
      interceptors: [AuthInterceptor(authToken)],
    );
  }

  Future<Account> getAccount(String authToken) async {
    final client = _newClient(authToken);
    final resp = await client.get(
      GetAccountRequest()
    );
    return resp.account;
  }

  Future<Account> updateName(String authToken, String name) async {
    final client = _newClient(authToken);
    final resp = await client.update(
      UpdateAccountRequest()
          ..path='name'
          ..value=name
    );
    return resp.account;
  }

  Future<Account> updatePassword(String authToken, String password) async {
    final client = _newClient(authToken);
    final resp = await client.update(
      UpdateAccountRequest()
          ..path='password'
          ..value=password
    );
    return resp.account;
  }

  Future<Account> acceptInvite(String authToken, String petId) async {
    final client = _newClient(authToken);
    final resp = await client.acceptInvite(
      AcceptInviteRequest()
          ..petId=petId
    );
    return resp.account;
  }
}