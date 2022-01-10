import 'package:flutter/material.dart';
import 'package:ohmnyom/src/deprecated/startup_bloc.dart';

class StartupBlocProvider extends InheritedWidget {
  final StartupBloc bloc;

  StartupBlocProvider({Key? key, required Widget child})
  : bloc = StartupBloc(),
  super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static StartupBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StartupBlocProvider>()!.bloc;
  }
}