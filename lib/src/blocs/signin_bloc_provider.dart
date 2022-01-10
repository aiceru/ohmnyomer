import 'package:flutter/material.dart';
import 'package:ohmnyom/src/blocs/signin_bloc.dart';

class SignInBlocProvider extends InheritedWidget {
  final SignInBloc bloc;

  SignInBlocProvider({Key? key, required Widget child})
  : bloc = SignInBloc(),
  super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static SignInBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SignInBlocProvider>()!.bloc;
  }
}