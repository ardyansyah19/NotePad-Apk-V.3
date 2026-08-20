import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/note.dart';

/// Lapisan penyimpanan lokal. Semua catatan disimpan secara permanen
/// di database SQLite pada perangkat, sehingga tetap ada walau aplikasi ditutup.
class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notepad.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT,
            type INTEGER NOT NULL,
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL,
            pinned INTEGER DEFAULT 0,
            hasAlarm INTEGER DEFAULT 0,
            alarmTime TEXT,
            locked INTEGER DEFAULT 0,
            checklist TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertNote(Note note) async {
    final db = await database;
    final map = note.toMap();
    map['checklist'] = jsonEncode(note.checklist.map((c) => c.toJson()).toList());
    map.remove('id');
    return db.insert('notes', map);
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    final map = note.toMap();
    map['checklist'] = jsonEncode(note.checklist.map((c) => c.toJson()).toList());
    return db.update('notes', map, where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Note>> fetchAllNotes() async {
    final db = await database;
    final rows = await db.query('notes', orderBy: 'pinned DESC, updatedAt DESC');
    return rows.map((r) {
      final note = Note.fromMap(r);
      final rawChecklist = r['checklist'] as String?;
      if (rawChecklist != null && rawChecklist.isNotEmpty) {
        final decoded = jsonDecode(rawChecklist) as List<dynamic>;
        note.checklist = decoded
            .map((e) => ChecklistItem.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return note;
    }).toList();
  }
}
