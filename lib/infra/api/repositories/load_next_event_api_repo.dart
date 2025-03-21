import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/infra/api/clients/http_get_client.dart';
import 'package:advanced_flutter/infra/api/mappers/next_event_mapper.dart';

class LoadNextEventApiRepository {
  final HttpGetClient httpClient;
  final String url;

  LoadNextEventApiRepository({required this.httpClient, required this.url});

  Future<NextEvent> loadNextEvent({required String groupId}) async {
    final event = await httpClient
        .get<Map<String, dynamic>>(url: url, params: {"groupId": groupId});
    return NextEventMapper.toObject(event);
  }
}
