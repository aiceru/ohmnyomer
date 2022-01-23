import 'package:flutter/cupertino.dart';
import 'package:ohmnyomer/src/blocs/sign_bloc.dart';

class SignBlocProvider extends InheritedWidget {
  final SignBloc bloc;

  SignBlocProvider({Key? key, required Widget child})
  : bloc = SignBloc(),
  super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static SignBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SignBlocProvider>()!.bloc;
  }
}