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
    String initials = '';

    if (names.length == 1) {
      initials = names.first.substring(0, 2);
    } else {
      final firstChar = names.first[0];
      final lastChar = names.last[0];
      initials = '$firstChar$lastChar';
    }

    return initials.toUpperCase();
  }
}
