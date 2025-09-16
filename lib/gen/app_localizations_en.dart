// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get contacts_title_page => 'Contacts Page';

  @override
  String get deleted_user_snackbar => 'User Deleted';

  @override
  String get edit_tooltip => 'Edit';

  @override
  String get delete_tooltip => 'Delete';

  @override
  String get no_contacts_label => 'No Contacts Registered';

  @override
  String hello(String name) {
    return 'Hello World $name';
  }
}
