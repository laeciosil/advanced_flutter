import 'package:flutter_test/flutter_test.dart';

class NextEventPlayer {
  NextEventPlayer._({
    required this.id,
    required this.name,
    required this.isConformed,
    required this.initials,
    this.confirmationDate,
    this.photo,
    this.position,
  });

  factory NextEventPlayer({
    required String id,
    required String name,
    required bool isConformed,
    String? photo,
    String? position,
    DateTime? confirmationDate,
  }) =>
      NextEventPlayer._(
          id: id,
          name: name,
          photo: photo,
          position: position,
          initials: _getInitials(name),
          isConformed: isConformed,
          confirmationDate: confirmationDate);

  final String id;
  final String name;
  final String? photo;
  final String? position;
  final bool isConformed;
  final String initials;
  final DateTime? confirmationDate;

  static String _getInitials(String name) {
    final names = name.split(' ');

    final firstChar = names.first[0];
    final lastChar = names.last[0];

    return '$firstChar$lastChar';
  }
}

void main() {
  String initialsOf(String name) => NextEventPlayer(
        id: '',
        name: name,
        isConformed: true,
      ).initials;

  test('Should return the first letter of the firs and last names ', () async {
    expect(initialsOf('Laecio Silva'), 'LS');

    expect(initialsOf('Pedro Carvalho'), 'PC');

    expect(initialsOf('Marcos Castro Da Silva'), 'MS');
  });
}
