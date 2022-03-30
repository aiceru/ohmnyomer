import 'package:dartnyom/protonyom_api_account.pbgrpc.dart';
import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:ohmnyomer/src/resources/apis/api_provider.dart';
import 'package:ohmnyomer/src/resources/apis/auth_interceptor.dart';

class AccountApiProvider {
  final ApiProvider _apiProvider;

  AccountApiProvider()
  : _apiProvider = ApiProvider();

  AccountApiClient _newClientWithAuth(String authToken) {
    return AccountApiClient(
      _apiProvider.channel,
      options: _apiProvider.callOptions,
      interceptors: [AuthInterceptor(authToken)],
    );
  }

  Future<Account> getAccount(String authToken) async {
    final client = _newClientWithAuth(authToken);
    final resp = await client.get(
      GetAccountRequest()
    );
    return resp.account;
  }

  Future<Account> updateName(String authToken, String name) async {
    final client = _newClientWithAuth(authToken);
    final resp = await client.update(
      UpdateAccountRequest()
          ..path='name'
          ..value=name
    );
    return resp.account;
  }

  Future<Account> updatePassword(String authToken, String password) async {
    final client = _newClientWithAuth(authToken);
    final resp = await client.update(
      UpdateAccountRequest()
          ..path='password'
          ..value=password
    );
    return resp.account;
  }

  Future<Account> acceptInvite(String authToken, String petId) async {
    final client = _newClientWithAuth(authToken);
    final resp = await client.acceptInvite(
      AcceptInviteRequest()
          ..petId=petId
    );
    return resp.account;
  }
}