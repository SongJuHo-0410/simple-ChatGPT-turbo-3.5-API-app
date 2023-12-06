import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseProvider {
  static final DatabaseProvider provider = DatabaseProvider();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await createDatabase();
    return _database!;
  }

  createDatabase() async {
    sqfliteFfiInit(); // Initialize sqflite ffi
    databaseFactory = databaseFactoryFfi; // Set the database factory

    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'chat.db');

    var database = await openDatabase(path, version: 1, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {
      // TODO :: Migration
    }
  }

  void initDB(Database database, int version) async {
    await database.execute(
        "CREATE TABLE chat_room_data(id integer PRIMARY KEY AUTOINCREMENT, title text, summ_index integer, last_id integer,FOREIGN KEY (summ_index) REFERENCES summary_data (id), FOREIGN KEY (last_id) REFERENCES chat_data (id))");
    await database
        .execute("CREATE TABLE chat_data(id integer, room_id integer, subject integer, chat text, PRIMARY KEY(id, room_id), FOREIGN KEY (room_id) REFERENCES chat_room_data (id))");
    await database.execute("CREATE TABLE summary_data(id integer, room_id integer, summary text, PRIMARY KEY(id, room_id), FOREIGN KEY (room_id) REFERENCES chat_room_data(id))");
  }
}
