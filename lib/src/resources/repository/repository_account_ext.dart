import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:ohmnyomer/src/resources/repository/repository.dart';

extension RepositoryAccountExt on Repository {
  Future<Account> fetchAccount() async {
    account = await accountApiProvider.getAccount(authToken!);
    if (account != null) {
      checkPetId(account!.pets);
    }
    return account!;
  }

  Future<Account> updateName(String name) async {
    account = await accountApiProvider.updateName(authToken!, name);
    return account!;
  }

  Future<Account> updatePassword(String password) async {
    account = await accountApiProvider.updatePassword(authToken!, password);
    return account!;
  }
}