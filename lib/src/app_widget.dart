import 'package:aula_flutter_web/src/pages/contacts/details/details_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        return DetailsPage(id: id);
      },
    ),
  ],
);

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
    // return MaterialApp(
    //   // home: const Page1(),
    //   initialRoute: '/',
    //   routes: {
    //     '/': (_) => const HomePage(),
    //     '/details': (context) {
    //       final args = ModalRoute.of(context)?.settings.arguments as int?;
    //       return DetailsPage(
    //         id: args,
    //       );
    //     },
    //     '/page1': (_) => Page1(),
    //     '/page2': (context) {
    //       final args =
    //           ModalRoute.of(context)?.settings.arguments
    //               as Map<String, dynamic>;
    //       return Page2(
    //         count: args['count'],
    //       );
    //     },
    //   },
    // );
  }
}
