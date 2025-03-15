import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/domain/entities/next_event_player.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';

class LoadNextEventApiRepository {
  final HttpGetClient httpClient;
  final String url;

  LoadNextEventApiRepository({required this.httpClient, required this.url});

  Future<NextEvent> loadNextEvent({required String groupId}) async {
    final event = await httpClient.get(url: url, params: {"groupId": groupId});
    return NextEventMapper.toObject(event);
  }
}

class NextEventMapper {
  static NextEvent toObject(Map<String, dynamic> json) => NextEvent(
        groupName: json['groupName'],
        date: DateTime.parse(json['date']),
        players: json['players']
            .map<NextEventPlayer>(
                (player) => NextEventPlayerMapper.toObject(player))
            .toList(),
      );
}

class NextEventPlayerMapper {
  static NextEventPlayer toObject(Map<String, dynamic> json) => NextEventPlayer(
        id: json['id'],
        name: json['name'],
        isConformed: json['isConfirmed'],
        confirmationDate: DateTime.tryParse(json['confirmationDate'] ?? ''),
        photo: json['photo'],
        position: json['position'],
      );
}

abstract class HttpGetClient {
  Future<dynamic> get({required String url, Map<String, String>? params});
}

class HttpGetClientSpy implements HttpGetClient {
  String? url;
  int callsCount = 0;
  Map<String, String>? params;
  dynamic response;
  Error? error;

  @override
  Future<dynamic> get(
      {required String url, Map<String, String>? params}) async {
    this.url = url;
    this.params = params;
    callsCount++;
    if (error != null) throw error!;
    return response;
  }
}

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
