import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/team.dart';
import '../models/team_member_model.dart';

class TeamDatabaseHelper {
  static final TeamDatabaseHelper _instance = TeamDatabaseHelper._();
  static Database? _database;

  TeamDatabaseHelper._();

  factory TeamDatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'task_management.db'), // Updated database name
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE team_members(id TEXT PRIMARY KEY, name TEXT, role TEXT, email TEXT)',
        );
        await db.execute(
          'CREATE TABLE teams(id TEXT PRIMARY KEY, teamName TEXT, members TEXT)',
        );
      },
      version: 1,
    );
  }

  // Team Member Methods
  Future<void> insertTeamMember(TeamMember member) async {
    final db = await database;
    await db.insert(
      'team_members',
      member.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TeamMember>> fetchTeamMembers() async {
    final db = await database;
    final maps = await db.query('team_members');
    return maps.map((map) => TeamMember.fromMap(map)).toList();
  }

  Future<void> updateTeamMember(TeamMember member) async {
    final db = await database;
    await db.update(
      'team_members',
      member.toMap(),
      where: 'id = ?',
      whereArgs: [member.id],
    );
  }

  Future<void> deleteTeamMember(String id) async {
    final db = await database;
    await db.delete('team_members', where: 'id = ?', whereArgs: [id]);
  }

  // Team Methods
  Future<void> insertTeam(Team team) async {
    final db = await database;
    await db.insert(
      'teams',
      team.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Team>> fetchTeams() async {
    final db = await database;
    final maps = await db.query('teams');
    return maps.map((map) => Team.fromMap(map)).toList();
  }

  Future<void> updateTeam(Team team) async {
    final db = await database;
    await db.update(
      'teams',
      team.toMap(),
      where: 'id = ?',
      whereArgs: [team.id],
    );
  }

  Future<void> deleteTeam(String id) async {
    final db = await database;
    await db.delete('teams', where: 'id = ?', whereArgs: [id]);
  }
}
