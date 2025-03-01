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
  NextEventPlayer makeSut(String name) => NextEventPlayer(
        id: '',
        name: name,
        isConformed: true,
      );

  test('Should return the first letter of the firs and last names ', () async {
    expect(makeSut('Laecio Silva').getInitialsLetters(), 'LS');

    expect(makeSut('Pedro Carvalho').getInitialsLetters(), 'PC');

    expect(makeSut('Marcos Castro Da Silva').getInitialsLetters(), 'MS');
  });
}
