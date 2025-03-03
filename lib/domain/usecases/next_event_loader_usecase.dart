import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/domain/repositories/load_next_events_repository.dart';

class NextEventLoader {
  NextEventLoader({
    required this.repo,
  });

  final LoadedNextEventRepository repo;

  Future<NextEvent> call({required String groupId}) async {
    return await repo.loadNextEvent(groupId: groupId);
  }
}
