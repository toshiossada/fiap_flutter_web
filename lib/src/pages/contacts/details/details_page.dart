import 'package:aula_flutter_web/src/pages/contacts/models/contact_model.dart';
import 'package:aula_flutter_web/src/pages/contacts/repositories/contact_repository.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  final int? id;
  const DetailsPage({super.key, this.id});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final repository = ContactRepository();
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  ContactModel? contact;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (widget.id != null) {
      final contact = await repository.getById(widget.id!);
      nameController.text = contact.name;
      emailController.text = contact.email;
      this.contact = contact;
      setState(() {});
    }
  }

  Future<void> salvar() async {
    // Salvar contato
    final newContact = ContactModel(
      id: contact?.id ?? 0,
      name: nameController.text,
      email: emailController.text,
    );
    if (widget.id == null) {
      await repository.insert(newContact);
    } else {
      await repository.update(newContact);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (widget.id == null)
            ? Text('Novo Contato')
            : Text('#${contact?.id} - ${contact?.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (widget.id == null) ? 'Novo Contato' : 'ID: ${contact?.id ?? ''}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              controller: nameController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Email'),
              controller: emailController,
            ),

            ElevatedButton(
              onPressed: () async {
                await salvar();

                if (context.mounted) {
                  Navigator.of(context).pop(true);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
