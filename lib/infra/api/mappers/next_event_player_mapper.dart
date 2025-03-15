import 'package:advanced_flutter/domain/entities/next_event_player.dart';

class NextEventPlayerMapper {
  static List<NextEventPlayer> toList(List<Map<String, dynamic>> arr) => arr
      .map<NextEventPlayer>((player) => NextEventPlayerMapper.toObject(player))
      .toList();

  static NextEventPlayer toObject(Map<String, dynamic> json) => NextEventPlayer(
        id: json['id'],
        name: json['name'],
        isConformed: json['isConfirmed'],
        confirmationDate: DateTime.tryParse(json['confirmationDate'] ?? ''),
        photo: json['photo'],
        position: json['position'],
      );
}
