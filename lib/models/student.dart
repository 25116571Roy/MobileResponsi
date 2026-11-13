class Student {
  final String name;
  final String nim;
  final String programStudi;
  final String email;

  const Student({
    required this.name,
    required this.nim,
    required this.programStudi,
    required this.email,
  });

  Student copyWith({
    String? name,
    String? nim,
    String? programStudi,
    String? email,
  }) {
    return Student(
      name: name ?? this.name,
      nim: nim ?? this.nim,
      programStudi: programStudi ?? this.programStudi,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nim': nim,
      'programStudi': programStudi,
      'email': email,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      name: map['name'] ?? '',
      nim: map['nim'] ?? '',
      programStudi: map['programStudi'] ?? '',
      email: map['email'] ?? '',
    );
  }
}
