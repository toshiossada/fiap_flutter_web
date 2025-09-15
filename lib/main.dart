import 'package:aula_flutter_web/src/app_widget.dart';
import 'package:flutter/material.dart';

import 'src/core/helper.dart'
    if (dart.library.html) 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {
  usePathUrlStrategy();
  runApp(AppWidget());
}
