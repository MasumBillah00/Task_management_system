
class TeamMember {
  String id;
  String name;
  String role;
  String email;

  TeamMember({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'email': email,
    };
  }

  factory TeamMember.fromMap(Map<String, dynamic> map) {
    return TeamMember(
      id: map['id'] ?? '',
      name: map['name'] ?? 'Unknown',
      role: map['role'] ?? 'No Role',
      email: map['email'] ?? 'No Email',
    );
  }
}

