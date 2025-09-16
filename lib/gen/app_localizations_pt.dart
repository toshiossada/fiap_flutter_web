// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get contacts_title_page => 'Página de contatos';

  @override
  String get deleted_user_snackbar => 'Usuario Deletado';

  @override
  String get edit_tooltip => 'Editar';

  @override
  String get delete_tooltip => 'Deletar';

  @override
  String get no_contacts_label => 'Nenhum contato cadastrado';

  @override
  String hello(String name) {
    return 'Olá Mundo! $name';
  }
}
