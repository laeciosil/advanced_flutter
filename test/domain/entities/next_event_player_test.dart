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

    return '${names.first[0]}${names.last[0]}';
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

    final initialsLetters = player.getInitialsLetters();

    expect(initialsLetters, 'LS');

    final player2 = NextEventPlayer(
      id: '',
      name: 'Pedro Carvalho',
      photo: '',
      position: '',
      isConformed: true,
      confirmationDate: DateTime.now(),
    );

    final initialsLetters2 = player2.getInitialsLetters();

    expect(initialsLetters2, 'PC');
  });
}
