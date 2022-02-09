import 'package:flutter/material.dart';
import 'package:ohmnyomer/src/blocs/pets_bloc.dart';

class PetsBlocProvider extends InheritedWidget {
  final PetsBloc bloc;

  PetsBlocProvider({Key? key, required Widget child})
  : bloc = PetsBloc(),
  super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static PetsBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PetsBlocProvider>()!.bloc;
  }
}