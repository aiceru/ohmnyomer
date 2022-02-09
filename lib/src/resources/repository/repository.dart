import 'package:dartnyom/protonyom_api_pet.pb.dart';
import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:flutter/material.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:ohmnyomer/src/resources/apis/account_api_provider.dart';
import 'package:ohmnyomer/src/resources/credential_provider.dart';
import 'package:ohmnyomer/src/resources/apis/pet_api_provider.dart';
import 'package:ohmnyomer/src/resources/apis/sign_api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Repository {
  static final Repository _repository = Repository._createInstance();
  Repository._createInstance();

  factory Repository() {
    return _repository;
  }

  Account? account;
  String? authToken;

  bool _rememberMe = false;
  bool _autoSignIn = false;
  String _signInEmail = "";
  SharedPreferences? _prefs;
  Map<String, Family>? familyMap;

  final CredentialProvider _credentialProvider = CredentialProvider();
  final SignApiProvider _signApiProvider = SignApiProvider();
  final AccountApiProvider _accountApiProvider = AccountApiProvider();
  final PetApiProvider _petApiProvider = PetApiProvider();

  CredentialProvider get credentialProvider => _credentialProvider;
  SignApiProvider get signApiProvider => _signApiProvider;
  AccountApiProvider get accountApiProvider => _accountApiProvider;
  PetApiProvider get petApiProvider => _petApiProvider;

  String _locale = 'en';
  String get locale => _locale;

  bool get rememberMe => _rememberMe;
  set rememberMe(bool value) {
    _setBoolPref(sharedPrefRememberMeKey, value);
    _rememberMe = value;
    if (!value) {
      _removePref(sharedPrefEmailKey);
      _signInEmail = "";
    }
  }

  bool get autoSignIn => _autoSignIn;
  set autoSignIn(bool value) {
    _setBoolPref(sharedPrefAutoLoginKey, value);
    _autoSignIn = value;
  }

  String get signInEmail => _signInEmail;
  set signInEmail(String value) {
    _setStringPref(sharedPrefEmailKey, value);
    _signInEmail = value;
  }

  Future<bool> initSharedPreference() async {
    _prefs = await SharedPreferences.getInstance();
    _autoSignIn = _getBoolPref(sharedPrefAutoLoginKey);
    _rememberMe = _getBoolPref(sharedPrefRememberMeKey);
    _signInEmail = _getStringPref(sharedPrefEmailKey);
    return true;
  }

  Future<bool> initConfigData(BuildContext context) async {
    _locale = Localizations.localeOf(context).languageCode;
    familyMap = await _petApiProvider.getSupportedFamilies(_locale);
    return true;
  }

  bool _getBoolPref(String key) {
    return _prefs?.getBool(key) ?? false;
  }
  _setBoolPref(String key, bool value) {
    _prefs?.setBool(key, value);
  }

  String _getStringPref(String key) {
    return _prefs?.getString(key) ?? "";
  }
  _setStringPref(String key, value) {
    _prefs?.setString(key, value);
  }

  _removePref(String key) async {
    _prefs?.remove(key);
  }
}