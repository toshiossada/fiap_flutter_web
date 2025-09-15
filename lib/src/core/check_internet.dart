import 'dart:io';

Future<bool> checkInternet() async {
  try {
    late List result;

    result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  return false;
}
