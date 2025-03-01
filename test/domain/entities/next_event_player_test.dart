import 'package:flutter_test/flutter_test.dart';

class NextEventPlayer {
  NextEventPlayer({
    required this.id,
    required this.name,
    required this.isConformed,
    this.confirmationDate,
    this.photo,
    this.position,
  }) {
    initials = _getInitials();
  }

  final String id;
  final String name;
  final String? photo;
  final String? position;
  final bool isConformed;
  late final String initials;
  final DateTime? confirmationDate;

  String _getInitials() {
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
