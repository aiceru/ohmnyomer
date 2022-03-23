// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `OhmNyom`
  String get appName {
    return Intl.message(
      'OhmNyom',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `LOG IN`
  String get login {
    return Intl.message(
      'LOG IN',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Edit display name`
  String get editName {
    return Intl.message(
      'Edit display name',
      name: 'editName',
      desc: '',
      args: [],
    );
  }

  /// `Enter new name`
  String get enterNewName {
    return Intl.message(
      'Enter new name',
      name: 'enterNewName',
      desc: '',
      args: [],
    );
  }

  /// `Enter new password`
  String get enterNewPassword {
    return Intl.message(
      'Enter new password',
      name: 'enterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Display name, Tap to edit`
  String get tapToEditName {
    return Intl.message(
      'Display name, Tap to edit',
      name: 'tapToEditName',
      desc: '',
      args: [],
    );
  }

  /// `Edit password`
  String get editPassword {
    return Intl.message(
      'Edit password',
      name: 'editPassword',
      desc: '',
      args: [],
    );
  }

  /// `********`
  String get obscuredPassword {
    return Intl.message(
      '********',
      name: 'obscuredPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password not set`
  String get passwordNotSet {
    return Intl.message(
      'Password not set',
      name: 'passwordNotSet',
      desc: '',
      args: [],
    );
  }

  /// `Tap to edit password`
  String get tapToEditPassword {
    return Intl.message(
      'Tap to edit password',
      name: 'tapToEditPassword',
      desc: '',
      args: [],
    );
  }

  /// `Not linked`
  String get oauthNotLinked {
    return Intl.message(
      'Not linked',
      name: 'oauthNotLinked',
      desc: '',
      args: [],
    );
  }

  /// `Linked account`
  String get linkedAccount {
    return Intl.message(
      'Linked account',
      name: 'linkedAccount',
      desc: '',
      args: [],
    );
  }

  /// `Joined at`
  String get joinedAt {
    return Intl.message(
      'Joined at',
      name: 'joinedAt',
      desc: '',
      args: [],
    );
  }

  /// `Adopted at`
  String get adoptedAt {
    return Intl.message(
      'Adopted at',
      name: 'adoptedAt',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Remember me`
  String get rememberMe {
    return Intl.message(
      'Remember me',
      name: 'rememberMe',
      desc: '',
      args: [],
    );
  }

  /// `Sign in automatically`
  String get signInAutomatically {
    return Intl.message(
      'Sign in automatically',
      name: 'signInAutomatically',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an Account? `
  String get dontHaveAnAccount {
    return Intl.message(
      'Don\'t have an Account? ',
      name: 'dontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `OR`
  String get or {
    return Intl.message(
      'OR',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `Sign In with`
  String get signInWith {
    return Intl.message(
      'Sign In with',
      name: 'signInWith',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `REGISTER`
  String get register {
    return Intl.message(
      'REGISTER',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Select pet`
  String get selectPet {
    return Intl.message(
      'Select pet',
      name: 'selectPet',
      desc: '',
      args: [],
    );
  }

  /// `Select kind`
  String get selectKind {
    return Intl.message(
      'Select kind',
      name: 'selectKind',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `too short, please enter {chars} characters or more`
  String tooShort(Object chars) {
    return Intl.message(
      'too short, please enter $chars characters or more',
      name: 'tooShort',
      desc: '',
      args: [chars],
    );
  }

  /// `Enter valid email`
  String get enterValidEmail {
    return Intl.message(
      'Enter valid email',
      name: 'enterValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Add new pet`
  String get addNewPet {
    return Intl.message(
      'Add new pet',
      name: 'addNewPet',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Delete?`
  String get pet_delete_confirm {
    return Intl.message(
      'Delete?',
      name: 'pet_delete_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Input error`
  String get input_error_title {
    return Intl.message(
      'Input error',
      name: 'input_error_title',
      desc: '',
      args: [],
    );
  }

  /// `Fill all inputs`
  String get pet_detail_input_error {
    return Intl.message(
      'Fill all inputs',
      name: 'pet_detail_input_error',
      desc: '',
      args: [],
    );
  }

  /// `No food in bowl!`
  String get feed_zero_amount {
    return Intl.message(
      'No food in bowl!',
      name: 'feed_zero_amount',
      desc: '',
      args: [],
    );
  }

  /// `Give me some more...`
  String get more_food_please {
    return Intl.message(
      'Give me some more...',
      name: 'more_food_please',
      desc: '',
      args: [],
    );
  }

  /// `Delete?`
  String get feed_delete_confirm {
    return Intl.message(
      'Delete?',
      name: 'feed_delete_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Ohmnyom`
  String get appTitle {
    return Intl.message(
      'Ohmnyom',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Invited co-parenting`
  String get invitedCoparenting {
    return Intl.message(
      'Invited co-parenting',
      name: 'invitedCoparenting',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ko'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
