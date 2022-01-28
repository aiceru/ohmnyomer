import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ohmnyomer/src/blocs/feed_bloc_provider.dart';
import 'package:ohmnyomer/src/blocs/sign_bloc_provider.dart';
import 'package:ohmnyomer/src/ui/edit_account_route.dart';
import 'package:ohmnyomer/src/ui/feed_route.dart';
import 'package:ohmnyomer/src/ui/signin_route.dart';
import 'package:ohmnyomer/src/ui/signup_route.dart';
import 'package:ohmnyomer/src/ui/splash_screen.dart';

import 'blocs/edit_account_bloc_provider.dart';

void main() => runApp(const AppMain());

class AppMain extends StatelessWidget {
  const AppMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
       statusBarColor: Colors.transparent,
       systemNavigationBarColor: Colors.transparent,
    ));

    return MaterialApp(
      title: '옴뇸뇸뇸',
      theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  primary: Colors.yellow,
                  onPrimary: Colors.black,
                  minimumSize: const Size(124, 60),
                  fixedSize: const Size(124, 60),
                  elevation: 6,
                  alignment: Alignment.center
              )
          )
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        SignInRoute.routeName: (context) => SignBlocProvider(child: const SignInRoute()),
        SignUpRoute.routeName : (context) => SignBlocProvider(child: const SignUpRoute()),
        FeedRoute.routeName: (context) => FeedBlocProvider(child: const FeedRoute()),
        EditAccountRoute.routeName: (context) => EditAccountBlocProvider(child: const EditAccountRoute()),
      },
    );
  }
}
