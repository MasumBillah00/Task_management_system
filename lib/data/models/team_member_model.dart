class TeamMember {
  String id; // Added id field for SQLite
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
      'id': id, // Ensure ID is included
      'name': name,
      'role': role,
      'email': email,
    };
  }

  factory TeamMember.fromMap(Map<String, dynamic> map) {
    return TeamMember(
      id: map['id'],
      name: map['name'],
      role: map['role'],
      email: map['email'],
    );
  }
}
