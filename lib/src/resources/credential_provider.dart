import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:ohmnyomer/src/models/credential.dart';

class CredentialProvider {
  static final _storage = FlutterSecureStorage();

  Future<Credential?> loadCredential() async {
    String? jsonCred = await _storage.read(key: secureStorageKeyCredential);
    if (jsonCred != null) {
      return Credential.fromJson(jsonDecode(jsonCred));
    }
    return null;
  }

  replaceCredential(Credential cred) {
    deleteCredential();
    saveCredential(cred);
  }

  saveCredential(Credential cred) {
    _storage.write(key: secureStorageKeyCredential, value: jsonEncode(cred));
  }

  deleteCredential() {
    _storage.delete(key: secureStorageKeyCredential);
  }
}