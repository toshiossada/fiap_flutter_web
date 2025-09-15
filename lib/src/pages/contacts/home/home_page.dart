import 'package:aula_flutter_web/src/app_controller.dart';
import 'package:aula_flutter_web/src/core/context_extension.dart';
import 'package:aula_flutter_web/src/pages/contacts/models/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../repositories/contact_remote_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final repository = ContactRemoteRepository();
  var contacts = <ContactModel>[];
  var loading = false;
  String? nextPage;
  final limit = 12;
  final _scrollController = ScrollController();
  bool isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadContacts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !loading &&
        !isFetchingMore &&
        nextPage != null) {
      isFetchingMore = true;
      fetchNextPage().then((_) {
        isFetchingMore = false;
      });
    }
  }

  _loadContacts({String? page}) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (page == null) {
        setState(() {
          loading = true;
        });
      }
      final (result, newPage) = await repository.getAll(
        limit: limit,
        page: page,
      );
      nextPage = newPage;
      if (page != null) {
        contacts.addAll(result);
      } else {
        contacts = result;
      }
      setState(() {
        loading = false;
      });
    });
  }

  fetchNextPage() async {
    if (nextPage == null) return;

    _loadContacts(page: nextPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.contacts_title_page),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchNextPage,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              value: appController.locale.languageCode,
              icon: const Icon(Icons.language, color: Colors.white),
              dropdownColor: Colors.white,
              onChanged: (String? newLocale) {
                if (newLocale != null) {
                  appController.store.locale = appController.supportedLocales
                      .firstWhere(
                        (element) => element.languageCode == newLocale,
                      );
                }
              },
              items: appController.supportedLocales.map((locale) {
                return DropdownMenuItem<String>(
                  value: locale.languageCode,
                  child: Text(
                    locale.languageCode.toUpperCase(),
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (loading) const Center(child: CircularProgressIndicator()),
          if (!loading && contacts.isEmpty)
            Center(child: Text(context.l10n.no_contacts_label)),
          if (!loading && contacts.isNotEmpty)
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: contacts.length + (nextPage != null ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == contacts.length && nextPage != null) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final contact = contacts[index];
                  return ListTile(
                    title: Text('${contact.id} - ${contact.name}'),
                    subtitle: Text(contact.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: context.l10n.edit_tooltip,
                          onPressed: () async {
                            context.go(
                              '/details/${contact.id}',
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: context.l10n.delete_tooltip,
                          onPressed: () async {
                            await repository.delete(contact.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    context.l10n.deleted_user_snackbar,
                                  ),
                                ),
                              );
                            }
                            _loadContacts();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          context.go('/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
