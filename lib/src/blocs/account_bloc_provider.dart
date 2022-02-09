import 'package:flutter/material.dart';
import 'package:ohmnyomer/src/blocs/account_bloc.dart';

class AccountBlocProvider extends InheritedWidget {
  final AccountBloc bloc;

  AccountBlocProvider({Key? key, required Widget child})
  : bloc = AccountBloc(),
  super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static AccountBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AccountBlocProvider>()!.bloc;
  }
}