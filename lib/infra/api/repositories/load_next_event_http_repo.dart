import 'dart:convert';

import 'package:advanced_flutter/domain/entities/domain_error.dart';
import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/domain/entities/next_event_player.dart';
import 'package:advanced_flutter/domain/repositories/load_next_events_repository.dart';
import 'package:http/http.dart';

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