import 'dart:convert';

import 'dart:typed_data';

import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/domain/entities/next_event_player.dart';
import 'package:advanced_flutter/domain/repositories/load_next_events_repository.dart';
import 'package:http/http.dart';

import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes.dart';

enum DomainError {
  unexpected,
  sessionExpired,
}

class LoadNextEventHttpRepository implements LoadedNextEventRepository {
  LoadNextEventHttpRepository({
    required this.httpClient,
    required this.url,
  });

  final Client httpClient;
  final String url;

  @override
  Future<NextEvent> loadNextEvent({required String groupId}) async {
    final uri = Uri.parse(url.replaceFirst(':groupId', groupId));
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    final response = await httpClient.get(uri, headers: headers);

    switch (response.statusCode) {
      case 200:
        break;
      case 401:
        throw DomainError.sessionExpired;
      default:
        throw DomainError.unexpected;
    }

    final event = jsonDecode(response.body);

    return NextEvent(
      groupName: event['groupName'],
      date: DateTime.parse(event['date']),
      players: event['players']
          .map<NextEventPlayer>(
            (player) => NextEventPlayer(
              id: player['id'],
              name: player['name'],
              isConformed: player['isConfirmed'],
              confirmationDate:
                  DateTime.tryParse(player['confirmationDate'] ?? ''),
              photo: player['photo'],
              position: player['position'],
            ),
          )
          .toList(),
    );
  }
}

class HttpClientSpy implements Client {
  String? method;
  int callsCount = 0;
  String? url;
  String responseJson = '';
  int statusCode = 200;
  Map<String, String>? headers;

  @override
  void close() {}

  @override
  Future<Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    throw UnimplementedError();
  }

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) async {
    method = 'get';
    callsCount++;
    this.url = url.toString();
    this.headers = headers;
    return Response(responseJson, statusCode);
  }

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) {
    throw UnimplementedError();
  }

  @override
  Future<Response> patch(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    throw UnimplementedError();
  }

  @override
  Future<Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    throw UnimplementedError();
  }

  @override
  Future<Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    throw UnimplementedError();
  }

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) {
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) {
    throw UnimplementedError();
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    throw UnimplementedError();
  }
}

void main() {
  late HttpClientSpy httpClient;
  late LoadNextEventHttpRepository sut;
  late String groupId;

  setUp(() {
    groupId = anyString();
    const url = 'https//domain.com/api/groups/:groupId/next_event';
    httpClient = HttpClientSpy();
    httpClient.responseJson = '''
      {
      "groupName": "any name",
      "date": "2025-03-10T15:30",
      "players": [{
        "id": "id 1",
        "name": "name 1",
        "isConfirmed": true
      }, {
        "id": "id 2",
        "name": "name 2",
        "position": "position 2",
        "photo": "photo 2",
        "confirmationDate": "2025-03-10T15:30",
        "isConfirmed": false      
      }]
      
      }
    ''';
    sut = LoadNextEventHttpRepository(httpClient: httpClient, url: url);
  });

  test('should request with correct method', () async {
    await sut.loadNextEvent(groupId: groupId);

    expect(httpClient.method, 'get');
    expect(httpClient.callsCount, 1);
  });

  test('should request with correct url', () async {
    await sut.loadNextEvent(groupId: groupId);

    expect(httpClient.url, 'https//domain.com/api/groups/$groupId/next_event');
  });

  test('should request with correct headers', () async {
    await sut.loadNextEvent(groupId: groupId);

    expect(httpClient.headers?['content-type'], 'application/json');
    expect(httpClient.headers?['accept'], 'application/json');
  });

  test('should return NextEvent on 200', () async {
    final event = await sut.loadNextEvent(groupId: groupId);

    expect(event.groupName, 'any name');
    expect(event.date, DateTime(2025, 3, 10, 15, 30));
    expect(event.players[0].id, 'id 1');
    expect(event.players[0].name, 'name 1');
    expect(event.players[0].isConformed, true);

    expect(event.players[1].id, 'id 2');
    expect(event.players[1].name, 'name 2');
    expect(event.players[1].isConformed, false);
    expect(event.players[1].position, 'position 2');
    expect(event.players[1].photo, 'photo 2');
    expect(event.date, DateTime(2025, 3, 10, 15, 30));
  });

  test('should throw UnexpectedError on 400', () async {
    httpClient.statusCode = 400;

    final future = sut.loadNextEvent(groupId: groupId);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError on 401', () async {
    httpClient.statusCode = 401;

    final future = sut.loadNextEvent(groupId: groupId);

    expect(future, throwsA(DomainError.sessionExpired));
  });

  test('should throw UnexpectedError on 403', () async {
    httpClient.statusCode = 403;

    final future = sut.loadNextEvent(groupId: groupId);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError on 404', () async {
    httpClient.statusCode = 404;

    final future = sut.loadNextEvent(groupId: groupId);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError on 500', () async {
    httpClient.statusCode = 500;

    final future = sut.loadNextEvent(groupId: groupId);

    expect(future, throwsA(DomainError.unexpected));
  });
}
