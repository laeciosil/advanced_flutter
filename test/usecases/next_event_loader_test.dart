import 'package:flutter_test/flutter_test.dart';

class NextEventLoader {
  NextEventLoader({
    required this.repo,
  });

  final LoadedNextEventRepository repo;

  Future<void> call({required String groupId}) async {
    await repo.loadNextEvent(groupId: groupId);
  }
}

abstract class LoadedNextEventRepository {
  Future<void> loadNextEvent({required String groupId});
}

@override
class LoadedNextEventMockRepository implements LoadedNextEventRepository {
  String? groupId;
  var callsCount = 0;

  Future<void> loadNextEvent({required String groupId}) async {
    this.groupId = groupId;
    callsCount++;
  }
}

void main() {
  test('Should load event data from repository', () async {
    final groupId = DateTime.now().millisecondsSinceEpoch.toString();

    final repo = LoadedNextEventMockRepository();
    final sut = NextEventLoader(repo: repo);
    await sut(groupId: groupId);

    expect(repo.groupId, groupId);
    expect(repo.callsCount, 1);
  });
}
