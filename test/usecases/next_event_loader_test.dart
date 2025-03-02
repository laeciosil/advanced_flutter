import 'dart:math';

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

class LoadedNextEventRepository {
  String? groupId;

  Future<void> loadNextEvent({required String groupId}) async {
    this.groupId = groupId;
  }
}

void main() {
  test('Should load event data from repository', () async {
    final groupId = DateTime.now().millisecondsSinceEpoch.toString();

     final repo = LoadedNextEventRepository();
    final sut = NextEventLoader(repo: repo);
    await sut(groupId: groupId);

    expect(repo.groupId, groupId);

  });

}
