import 'package:advanced_flutter/domain/entities/next_event_player.dart';
import 'package:flutter_test/flutter_test.dart';


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

    expect(initialsOf('edison sousa'), 'ES');
  });

  test('Should return the firs letters of the first name', () async {
    expect(initialsOf('Laecio'), 'LA');
    expect(initialsOf('Pedro'), 'PE');
    expect(initialsOf('Marcos'), 'MA');
    expect(initialsOf('fabio'), 'FA');
  });
}
