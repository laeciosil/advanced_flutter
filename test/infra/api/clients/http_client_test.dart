import 'package:dartx/dartx.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

import '../../../helpers/fakes.dart';
import 'client_spy.dart';

class HttpClient {
  final Client client;

  HttpClient({required this.client});

  Future<void> get(
      {required String url,
      Map<String, dynamic>? params,
      Map<String, dynamic>? queryStrings}) async {
    final uri = _buildUri(url: url, params: params);

    await client.get(uri);
  }

  Uri _buildUri(
      {required String url,
      Map<String, dynamic>? params,
      Map<String, dynamic>? queryString}) {
    url = params?.keys
            .fold(
                url,
                (result, key) =>
                    result.replaceFirst(':$key', params[key] ?? ''))
            .removeSuffix('/') ??
        url;
    url = queryString?.keys
            .fold('$url?', (result, key) => '$result$key=${queryString[key]}&')
            .removeSuffix('&') ??
        url;
    return Uri.parse(url);
  }
}

void main() {
  late ClientSpy client;
  late HttpClient sut;
  late String url;

  setUp(() {
    client = ClientSpy();
    sut = HttpClient(client: client);
    url = anyString();
  });

  test('should request with correct method', () async {
    await sut.get(url: url);

    expect(client.method, 'get');
    expect(client.callsCount, 1);
  });

  test('should request with correct url', () async {
    await sut.get(url: url);

    expect(client.url, url);
    expect(client.callsCount, 1);
  });

  test('should request with correct params', () async {
    url = 'http://anyurl.com/:p1/:p2';

    await sut.get(url: url, params: {'p1': 'v1', 'p2': 'v2'});

    expect(client.url, 'http://anyurl.com/v1/v2');
  });
}
