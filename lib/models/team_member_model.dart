class TeamMember {
  String name;
  String role;
  String email;

  TeamMember({
    required this.name,
    required this.role,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': role,
      'email': email,
    };
  }

  factory TeamMember.fromMap(Map<String, dynamic> map) {
    return TeamMember(
      name: map['name'],
      role: map['role'],
      email: map['email'],
    );
  }
}
