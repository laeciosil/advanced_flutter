import 'package:advanced_flutter/domain/entities/domain_error.dart';
import 'package:advanced_flutter/infra/api/repositories/load_next_event_http_repo.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';
import '../clients/http_client_spy.dart';

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
