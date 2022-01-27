import 'package:flutter/material.dart';
import 'package:ohmnyomer/src/resources/repository.dart';
import 'package:ohmnyomer/src/ui/signin_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const routeName = '/SplashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            Repository().init(snapshot.data!);
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed(SignInRoute.routeName);
            });
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}