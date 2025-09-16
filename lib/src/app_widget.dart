import 'package:aula_flutter_web/src/app_controller.dart';
import 'package:aula_flutter_web/src/pages/contacts/details/details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import '../gen/app_localizations.dart';
import 'pages/contacts/home/home_page.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, _) => HomePage(),
    ),
    GoRoute(
      path: '/create',
      builder: (_, state) {
        return DetailsPage();
      },
    ),
    GoRoute(
      path: '/details/:id',
      builder: (_, state) {
        final idStr = state.pathParameters['id'];
        final id = idStr != null ? int.tryParse(idStr) : null;
        return DetailsPage(id: idStr);
      },
    ),
  ],
);

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});
  static const Iterable<LocalizationsDelegate<dynamic>> localizations = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appController.store,
      builder: (_, _) {
        return MaterialApp.router(
          localizationsDelegates: localizations,
          supportedLocales: appController.supportedLocales,
          locale: appController.locale,
          routerConfig: _router,
        );
      },
    );
  }
}
