import 'dart:convert';

import 'package:experiment_sdk_flutter/types/experiment_variant.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  @protected
  Map<String, ExperimentVariant> map = {};

  LocalStorage({required String apiKey});

  void put(String key, ExperimentVariant value) {
    map[key] = value;
  }

  ExperimentVariant? get(String key) {
    final variant = map[key];

    return variant;
  }

  void clear() {
    map = {};
  }

  Map<String, ExperimentVariant> getAll() {
    return map;
  }

  void load() async {
    final prefs = await SharedPreferences.getInstance();

    final keys = prefs.getKeys();
    Map<String, ExperimentVariant> newMap = {};

    for (String key in keys) {
      try {
        dynamic value = prefs.get(key);
        newMap[key] = ExperimentVariant.fromMap(jsonDecode(value));
      } catch (_) {
        // ignore
      }
    }

    map = newMap;
  }

  void save() async {
    final prefs = await SharedPreferences.getInstance();

    map.forEach((key, value) {
      prefs.setString(key, value.toJsonAsString());
    });
  }
}
