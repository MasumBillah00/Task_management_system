class Team {
  String id; // Added id field for SQLite
  String teamName;
  List<String> members; // Store member IDs

  Team({
    required this.id,
    required this.teamName,
    required this.members,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'teamName': teamName,
      'members': members.join(','), // Store members as comma-separated string
    };
  }

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id'],
      teamName: map['teamName'],
      members: (map['members'] as String).split(','), // Split back to list
    );
  }
}
