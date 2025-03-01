import 'package:flutter_test/flutter_test.dart';

class NextEventPlayer {
  const NextEventPlayer({
    required this.id,
    required this.name,
    required this.isConformed,
    this.confirmationDate,
    this.photo,
    this.position,
  });

  final String id;
  final String name;
  final String? photo;
  final String? position;
  final bool isConformed;
  final DateTime? confirmationDate;

  String getInitialsLetters() {
    final names = name.split(' ');

    final firstChar = names.first[0];
    final lastChar = names.last[0];

    return '$firstChar$lastChar';
  }
}

void main() {
  test('Should return the first letter of the firs and last names ', () async {
    final player = NextEventPlayer(
      id: '',
      name: 'Laecio Silva',
      photo: '',
      position: '',
      isConformed: true,
      confirmationDate: DateTime.now(),
    );

    expect(player.getInitialsLetters(), 'LS');

    final player2 = NextEventPlayer(
      id: '',
      name: 'Pedro Carvalho',
      photo: '',
      position: '',
      isConformed: true,
      confirmationDate: DateTime.now(),
    );

    expect(player2.getInitialsLetters(), 'PC');

    final player3 = NextEventPlayer(
      id: '',
      name: 'Marcos Castro Da Silva',
      photo: '',
      position: '',
      isConformed: true,
      confirmationDate: DateTime.now(),
    );

    expect(player3.getInitialsLetters(), 'MS');
  });
}
