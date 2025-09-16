import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../pages/contacts/models/contact_model.dart';

class ContactLocalRepository {
  Future<void> delete(String id) async {
    final prefs = await completer.future;
    final contacts = await getAll();
    contacts.removeWhere((e) {
      return e.id == id;
    });

    await prefs.setStringList(
      'contacts',
      contacts.map((e) => e.toJson()).toList(),
    );
  }

  final completer = Completer<SharedPreferences>();

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    completer.complete(prefs);
  }

  ContactLocalRepository() {
    init();
  }

  Future<void> insert(ContactModel contact) async {
    final prefs = await completer.future;
    final contacts = await getAll();
    // contact.id =
    //     contacts.fold<int>(
    //       0,
    //       (maxId, contact) => contact.id > maxId ? contact.id : maxId,
    //     ) +
    //     1;
    contacts.add(contact);
    await prefs.setStringList(
      'contacts',
      contacts.map((e) => e.toJson()).toList(),
    );
  }

  Future<List<ContactModel>> getAll() async {
    final prefs = await completer.future;
    final contacts = prefs.getStringList('contacts') ?? [];
    return contacts.map((e) => ContactModel.fromJson(e)).toList();
  }

  Future<ContactModel> getById(int id) async {
    final contacts = await getAll();
    return contacts.firstWhere((element) => element.id == id);
  }

  Future<void> update(ContactModel contact) async {
    final prefs = await completer.future;
    final contacts = await getAll();
    final index = contacts.indexWhere((e) => e.id == contact.id);
    if (index != -1) {
      contacts[index] = contact;
      await prefs.setStringList(
        'contacts',
        contacts.map((e) => e.toJson()).toList(),
      );
    }
  }
}
