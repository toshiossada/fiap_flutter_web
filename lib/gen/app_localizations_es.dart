// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get contacts_title_page => 'Página de contactos';

  @override
  String get deleted_user_snackbar => 'Usuario eliminado';

  @override
  String get edit_tooltip => 'Editar';

  @override
  String get delete_tooltip => 'Deletar';

  @override
  String get no_contacts_label => 'Ningún contacto registrado';

  @override
  String hello(String name) {
    return '¡Hola Mundo! $name';
  }
}
