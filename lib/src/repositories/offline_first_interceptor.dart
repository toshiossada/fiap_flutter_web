import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

/// Interceptor que prioriza cache local quando offline.
class OfflineFirstInterceptor extends Interceptor {
  final Future<bool> Function() isOffline;

  OfflineFirstInterceptor({required this.isOffline});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (await isOffline()) {
      // Marque a requisição para fallback local
      options.extra['offline'] = true;
    }
    handler.next(options);
  }

  // Você pode adicionar lógica para onResponse/onError se quiser manipular cache
}

/// Função utilitária para checar conectividade
Future<bool> isDeviceOffline() async {
  final connectivity = await Connectivity().checkConnectivity();
  return connectivity == ConnectivityResult.none;
}
