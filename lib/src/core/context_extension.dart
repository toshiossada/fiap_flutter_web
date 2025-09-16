import 'package:flutter/material.dart';

import '../../../../../gen/app_localizations.dart';

extension ContextExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
