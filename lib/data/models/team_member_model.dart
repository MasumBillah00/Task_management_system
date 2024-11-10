class TeamMember {
  String id; // Added id field for SQLite
  String name;
  String role;
  String email;
  String password;

  TeamMember({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Ensure ID is included
      'name': name,
      'role': role,
      'email': email,
      'password': password
    };
  }

  factory TeamMember.fromMap(Map<String, dynamic> map) {
    return TeamMember(
      id: map['id'] ?? '', // Default to empty string if null
      name: map['name'] ?? 'Unknown', // Default to 'Unknown' if null
      role: map['role'] ?? 'No Role', // Default to 'No Role' if null
      email: map['email'] ?? 'No Email', // Default to 'No Email' if null
      password: map['password'] ??' password'
    );
  }
}
