import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ohmnyomer/src/blocs/feed_bloc_provider.dart';
import 'package:ohmnyomer/src/blocs/sign_bloc_provider.dart';
import 'package:ohmnyomer/src/ui/routes/account_route.dart';
import 'package:ohmnyomer/src/ui/routes/pets_route.dart';
import 'package:ohmnyomer/src/ui/routes/feed_route.dart';
import 'package:ohmnyomer/src/ui/routes/signin_route.dart';
import 'package:ohmnyomer/src/ui/routes/signup_route.dart';
import 'package:ohmnyomer/src/ui/routes/splash_route.dart';

import 'blocs/account_bloc_provider.dart';
import 'blocs/pets_bloc_provider.dart';

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
                  primary: Colors.yellow,
                  onPrimary: Colors.black,
                  minimumSize: const Size(124, 60),
                  fixedSize: const Size(124, 60),
                  elevation: 6,
                  alignment: Alignment.center
              )
          )
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: SplashRoute.routeName,
      routes: {
        SplashRoute.routeName: (context) => const SplashRoute(),
        SignInRoute.routeName: (context) => SignBlocProvider(child: const SignInRoute()),
        SignUpRoute.routeName : (context) => SignBlocProvider(child: const SignUpRoute()),
        FeedRoute.routeName: (context) => FeedBlocProvider(child: const FeedRoute()),
        AccountRoute.routeName: (context) => AccountBlocProvider(child: const AccountRoute()),
        PetsRoute.routeName: (context) => PetsBlocProvider(child: const PetsRoute()),
      },
    );
  }
}
