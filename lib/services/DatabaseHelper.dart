import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../model/news_item.dart';

class DatabaseHelper {
  static Database? _database;
  static const String tableNews = 'news';
  static const String tablePrompts = 'prompts';
  static const String tableTimestamps = 'timestamps';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join((await getApplicationDocumentsDirectory()).path, 'news.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableNews (
            id TEXT PRIMARY KEY,
            title TEXT,
            summary TEXT,
            details TEXT,
            sourceUrl TEXT,
            source TEXT,
            date TEXT,
            responseType TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE $tablePrompts (
            id TEXT PRIMARY KEY,
            title TEXT,
            summary TEXT,
            details TEXT,
            sourceUrl TEXT,
            source TEXT,
            date TEXT,
            responseType TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE $tableTimestamps (
            id TEXT PRIMARY KEY,
            timestamp TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertNewsItems(List<NewsItem> items) async {
    final db = await database;
    final batch = db.batch();
    for (var item in items) {
      batch.insert(
        tableNews,
        {'id': md5.convert(utf8.encode(item.title)).toString(), ...item.toMap()},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  Future<List<NewsItem>> getNewsItems() async {
    final db = await database;
    final maps = await db.query(tableNews);
    return maps.map((map) => NewsItem.fromMap(map)).toList();
  }

  Future<void> insertPromptResponse(String id, NewsItem item) async {
    final db = await database;
    await db.insert(
      tablePrompts,
      {'id': id, ...item.toMap()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NewsItem>> getPromptResponses() async {
    final db = await database;
    final maps = await db.query(tablePrompts);
    return maps.map((map) => NewsItem.fromMap(map)).toList();
  }

  Future<void> saveTimestamp(String key, String timestamp) async {
    final db = await database;
    await db.insert(
      tableTimestamps,
      {'id': key, 'timestamp': timestamp},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getTimestamp(String key) async {
    final db = await database;
    final maps = await db.query(tableTimestamps, where: 'id = ?', whereArgs: [key]);
    return maps.isNotEmpty ? maps.first['timestamp'] as String? : null;
  }
}