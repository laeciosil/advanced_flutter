import 'package:advanced_flutter/infra/api/repositories/load_next_event_api_repo.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';
import '../clients/http_get_client_spy.dart';

void main() {
  late HttpGetClientSpy httpClient;
  late LoadNextEventApiRepository sut;
  late String url;
  late String groupId;

  setUp(() {
    groupId = anyString();
    url = anyString();
    httpClient = HttpGetClientSpy();
    httpClient.response = {
      "groupName": "any name",
      "date": "2025-03-10T15:30",
      "players": [
        {"id": "id 1", "name": "name 1", "isConfirmed": true},
        {
          "id": "id 2",
          "name": "name 2",
          "position": "position 2",
          "photo": "photo 2",
          "confirmationDate": "2025-03-10T15:30",
          "isConfirmed": false
        }
      ]
    };

    sut = LoadNextEventApiRepository(httpClient: httpClient, url: url);
  });

  test('should call HttpClient with correct input', () async {
    await sut.loadNextEvent(groupId: groupId);

    expect(httpClient.url, url);
    expect(httpClient.callsCount, 1);
    expect(httpClient.params, {"groupId": groupId});
  });

  test('should return NextEvent on success', () async {
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

  test('should throw UnexpectedError on error', () async {
    final error = Error();
    httpClient.error = error;

    final future = sut.loadNextEvent(groupId: groupId);

    expect(future, throwsA(error));
  });
}
