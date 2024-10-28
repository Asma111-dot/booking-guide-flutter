import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../storage/auth_storage.dart' as auth_store;
import '../storage/settings_storage.dart' as settings_store;

/// Initiate Hive, register adapters and open boxes
Future init() async {
  await Hive.initFlutter();

  await auth_store.open();
  await settings_store.open();
}

/// get an open box
Box<T> box<T>(String name, [bool secure = true]) {
  return Hive.box<T>(name);
}

/// Opens a box if closed
Future<void> openBox<T>(String name, [bool secure = true]) async {
  if (!Hive.isBoxOpen(name)) {
    await Hive.openBox<T>(name,
        encryptionCipher: await _encrypt(secure ? name : null));
  }
}

/// Closes an open box
Future closeBox<T>(String name) async {
  if (Hive.isBoxOpen(name)) {
    return await Hive.box<T>(name).close();
  }
}

/// Clears an existed box
Future deleteBox<T>(String name) async {
  if (await Hive.boxExists(name)) {
    await Hive.box(name).clear();
  }
}

/// Generate a hive cypher encryption
Future<HiveAesCipher?> _encrypt([String? storageKey]) async {
  if (storageKey?.isEmpty ?? true) return null;

  var secureStorage = const FlutterSecureStorage();
  late String encryptionKey;

  await secureStorage.read(key: storageKey!).then((String? value) async {
    if (value == null) {
      final key = Hive.generateSecureKey();
      await secureStorage.write(
        key: storageKey,
        value: base64UrlEncode(key),
      );
      encryptionKey = await secureStorage.read(key: storageKey) ?? '';
    } else {
      encryptionKey = value;
    }
  });

  return HiveAesCipher(base64Url.decode(encryptionKey));
}
