import 'package:dio/dio.dart';

import '../core/interceptor/common_interceptor.dart';
import '../pages/contacts/models/contact_model.dart';

class ContactRemoteRepository {
  final projectId = 'aula-fiap-3e611';
  late final http = Dio(
    BaseOptions(
      baseUrl:
          'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents',
    ),
  );

  ContactRemoteRepository() {
    http.interceptors.add(CommonInterceptor());
  }

  Future<void> delete(String id) async {
    await http.delete('/contacts/$id');
  }

  Future<void> insert(ContactModel contact) async {
    await http.post(
      '/contacts',
      data: contact.toFirebase(),
    );
  }

  Future<(List<ContactModel>, String?)> getAll({
    String? page,
    int? limit,
  }) async {
    final response = await http.get(
      '/contacts',
      queryParameters: {
        'pageSize': limit ?? 0,
        'pageToken': page,
      },
    );
    if (response.statusCode == 200) {
      final data = response.data['documents'] as List;
      final result = data.map((e) => ContactModel.fromFirebase(e)).toList();
      return (
        result,
        response.data['nextPageToken'] as String?,
      );
    }
    return (<ContactModel>[], null);
  }

  Future<ContactModel> getById(String id) async {
    final response = await http.get('/contacts/$id');
    if (response.statusCode == 200) {
      return ContactModel.fromFirebase(response.data);
    }
    return ContactModel(name: '', email: '');
  }

  Future<void> update(ContactModel contact) async {
    await http.patch(
      '/contacts/${contact.id}',
      data: contact.toFirebase(),
    );
  }
}
