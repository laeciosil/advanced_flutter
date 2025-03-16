import 'package:advanced_flutter/infra/api/clients/http_get_client.dart';

class HttpGetClientSpy implements HttpGetClient {
  String? url;
  int callsCount = 0;
  Map<String, String>? params;
  dynamic response;
  Error? error;

  @override
  Future<T> get<T>({required String url, Map<String, String>? params}) async {
    this.url = url;
    this.params = params;
    callsCount++;
    if (error != null) throw error!;
    return response;
  }
}