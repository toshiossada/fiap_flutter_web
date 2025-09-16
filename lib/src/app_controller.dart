import 'package:flutter/material.dart';

final _store = AppStore();
final appController = AppController(store: _store);

class AppController {
  final AppStore store;
  Iterable<Locale> get supportedLocales => store.supportedLocales;
  Locale get locale => store._locale;


  AppController({
    required this.store,
  });
}

class AppStore extends ChangeNotifier {
  final Iterable<Locale> supportedLocales = [
    const Locale('en'),
    const Locale('es'),
    const Locale('pt'),
  ];

  Locale _locale = WidgetsBinding.instance.platformDispatcher.locale;

  Locale get locale {
    if (supportedLocales.any((e) => e.languageCode == _locale.languageCode)) {
      return _locale;
    }
    return supportedLocales.first;
  }

  set locale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
