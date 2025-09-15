import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../repositories/offlinelocal_repository.dart';
import '../check_internet.dart';

class CommonInterceptor extends InterceptorsWrapper {
  CommonInterceptor();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (kDebugMode) {
      log(json.encode('BaseURL: ${options.baseUrl}'), name: 'Request[BaseURL]');
      log(json.encode('Endpoint: ${options.path}'), name: 'Request[Endpoint]');
      if (options.headers['access-token'] != null) {
        log(
          json.encode('access-token: ${options.headers['access-token']}'),
          name: 'Request[access-token]',
        );
      }
      if (options.data != null) {
        log(
          json.encode('Payload: ${json.encode(options.data)}'),
          name: 'Request[Payload]',
        );
      }
    }

    final connected = await checkInternet();
    // Se não estiver conectado e for um GET de contatos, retorna do local
    if (!connected &&
        options.method == 'GET') {
      final localRepo = OfflineLocalRepository();
      final data = await localRepo.getAll(options.path);
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: data,
        ),
      );
      return;
    }
    handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (kDebugMode) {
      log(json.encode('Response: ${response.data}'), name: 'Response');
    }

    // Salvar resposta no repositório offline se for contatos
    if (response.requestOptions.method == 'GET') {
      final localRepo = OfflineLocalRepository();
      await localRepo.insert(response.data, response.requestOptions.path);
    }
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    handler.next(err);
  }
}
