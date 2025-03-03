import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/domain/entities/next_event_player.dart';
import 'package:advanced_flutter/domain/repositories/load_next_events_repository.dart';
import 'package:advanced_flutter/domain/usecases/next_event_loader.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';

class LoadedNextEventSpyRepository implements LoadedNextEventRepository {
  String? groupId;
  var callsCount = 0;
  NextEvent? output;
  Error? error;

  @override
  Future<NextEvent> loadNextEvent({required String groupId}) async {
    this.groupId = groupId;
    callsCount++;

    if (error != null) throw error!;
    return output!;
  }
}

void main() {
  late String groupId;
  late LoadedNextEventSpyRepository repo;
  late NextEventLoader sut;

  setUp(() {
    groupId = anyString();
    repo = LoadedNextEventSpyRepository();
    repo.output = NextEvent(
      groupName: 'any group name',
      date: DateTime.now(),
      players: [
        NextEventPlayer(
          id: 'any id 1',
          name: 'any name 1',
          photo: 'any photo 1',
          isConformed: true,
          confirmationDate: DateTime.now(),
        ),
        NextEventPlayer(
          id: 'any id 2',
          name: 'any name 2',
          isConformed: false,
          position: 'any position 2',
          confirmationDate: DateTime.now(),
        )
      ],
    );
    sut = NextEventLoader(repo: repo);
  });

  test('Should load event data from repository', () async {
    await sut(groupId: groupId);

    expect(repo.groupId, groupId);
    expect(repo.callsCount, 1);
  });

  test('Should load event data on success', () async {
    final event = await sut(groupId: groupId);

    expect(event.groupName, repo.output?.groupName);
    expect(event.date, repo.output?.date);
    expect(event.players.length, 2);
    expect(event.players[0].id, repo.output?.players[0].id);
    expect(event.players[0].name, repo.output?.players[0].name);
    expect(event.players[0].initials, isNotEmpty);
    expect(event.players[0].photo, repo.output?.players[0].photo);
    expect(event.players[0].isConformed, repo.output?.players[0].isConformed);
    expect(event.players[0].confirmationDate,
        repo.output?.players[0].confirmationDate);

    expect(event.players[1].id, repo.output?.players[1].id);
    expect(event.players[1].name, repo.output?.players[1].name);
    expect(event.players[1].initials, isNotEmpty);
    expect(event.players[1].position, repo.output?.players[1].position);
    expect(event.players[1].isConformed, repo.output?.players[1].isConformed);
    expect(event.players[1].confirmationDate,
        repo.output?.players[1].confirmationDate);
  });

  test('Should rethrow on error', () async {
    final error = Error();
    repo.error = error;
    final future = sut(groupId: groupId);
    expect(future, throwsA(error));
  });
}
