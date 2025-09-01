import 'package:aula_flutter_web/src/pages/contacts/models/contact_model.dart';
import 'package:aula_flutter_web/src/pages/contacts/repositories/contact_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final repository = ContactRepository();
  var contacts = <ContactModel>[];
  var loading = false;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  _loadContacts() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        loading = true;
      });
      // await Future.delayed(const Duration(seconds: 3));
      contacts = await repository.getAll();

      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts Home Page')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (loading) const Center(child: CircularProgressIndicator()),
          if (!loading && contacts.isEmpty)
            const Center(child: Text('Nenhum contato cadastrado')),
          if (!loading && contacts.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return ListTile(
                    title: Text('${contact.id} - ${contact.name}'),
                    subtitle: Text(contact.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Editar',
                          onPressed: () async {
                            // final value = await Navigator.pushNamed(
                            //   context,
                            //   '/details',
                            //   arguments: contact.id,
                            // );
                            final value = await context.push(
                              '/details/${contact.id}',
                            );
                            if (value == true) {
                              _loadContacts();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: 'Deletar',
                          onPressed: () async {
                            await repository.delete(contact.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Usuario Deletado'),
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
          // final value = await Navigator.pushNamed(
          //   context,
          //   '/details',
          // );
          final value = await context.push('/create');
          if (value == true) {
            _loadContacts();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
