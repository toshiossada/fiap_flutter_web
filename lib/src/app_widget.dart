import 'package:aula_flutter_web/src/pages/contacts/details/details_page.dart';
import 'package:aula_flutter_web/src/pages/page1/page1.dart';
import 'package:aula_flutter_web/src/pages/page2/page2.dart';
import 'package:flutter/material.dart';

import 'pages/contacts/home/home_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: const Page1(),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomePage(),
        '/details': (_) {
          final args = ModalRoute.of(context)?.settings.arguments as int?;
          return DetailsPage(
            id: args,
          );
        },
        '/page1': (_) => Page1(),
        '/page2': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>;
          return Page2(
            count: args['count'],
          );
        },
      },
    );
  }
}
