import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class OfflineLocalRepository {
  final completer = Completer<SharedPreferences>();

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    completer.complete(prefs);
  }

  OfflineLocalRepository() {
    init();
  }

  Future<void> insert(Map<String, dynamic> data, String url) async {
    final prefs = await completer.future;

    await prefs.setString(
      url,
      json.encode(data),
    );
  }

  Future<Map<String, dynamic>> getAll(String url) async {
    final prefs = await completer.future;
    final data = prefs.getString(url);
    return data != null ? json.decode(data) : {};
  }
}
