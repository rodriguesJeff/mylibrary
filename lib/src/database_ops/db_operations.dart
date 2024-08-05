import 'dart:developer' show log;

import 'package:my_library/src/models/base_model.dart';
import 'package:my_library/src/utils/app_strings.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseOperations {
  static final DataBaseOperations _instance = DataBaseOperations._internal();
  late Database database;
  bool _initialized = false;

  factory DataBaseOperations() {
    return _instance;
  }

  DataBaseOperations._internal();

  Future<void> initOperations() async {
    if (!_initialized) {
      database = await openDatabase(
        join(await getDatabasesPath(), 'my_library.db'),
        version: 1,
        onCreate: (db, version) async {
          await createTables(db);
          await addStatusContents(db);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 1) {
            await createTables(db);
          }
        },
      );
      _initialized = true;
    }
  }

  Future<void> insertData(BaseModel obj, String table) async {
    try {
      await initOperations();
      await database.insert(
        table,
        obj.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      log("Erro ao inserir dados: $e");
    }
  }

  Future<List<Map<String, Object?>>> getData(String table) async {
    try {
      await initOperations();
      final List<Map<String, Object?>> map = await database.query(table);

      return map;
    } catch (e) {
      log("Erro ao buscar dados: $e");
    }
    return [];
  }

  Future<Map<String, Object?>?> getOneData(String table, String id) async {
    try {
      await initOperations();
      final List<Map<String, Object?>> map = await database.query(
        table,
        where: 'id = ?',
        whereArgs: [id],
      );

      return map.first;
    } catch (e) {
      log("Erro ao buscar dado específico: $e");
    }
    return null;
  }

  Future<void> updateBook(BaseModel obj, String table, String id) async {
    await initOperations();
    await database.update(
      table,
      obj.toJson(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteBook(int id, String table) async {
    await initOperations();
    await database.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> createTables(Database db) async {
    log("INÍCIO - CRIANDO TABELAS");
    await db.execute('''
    CREATE TABLE IF NOT EXISTS ${AppStrings.userTable} (
      id TEXT PRIMARY KEY,
      name VARCHAR(100),
      photo VARCHAR(1000)
    );
    ''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS ${AppStrings.statusTable} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      description VARCHAR(100)
    );
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS ${AppStrings.bookTable} (
      id TEXT PRIMARY KEY,
      title VARCHAR(100),
      author VARCHAR(100),
      total_pages INT,
      read_pages INT,
      start_date DATE,
      end_date DATE,
      user_id TEXT,
      status_id TEXT,
      FOREIGN KEY(user_id) REFERENCES User(id),
      FOREIGN KEY(status_id) REFERENCES Status(id)
    );
    ''');

    await listTables(db);
    log("FIM - TABELAS CRIADAS");
  }

  Future<void> addStatusContents(Database db) async {
    await db.insert(AppStrings.statusTable, {
      'description': 'Lendo',
    });

    await db.insert(AppStrings.statusTable, {
      'description': 'Concluído',
    });

    await db.insert(AppStrings.statusTable, {
      'description': 'Cancelado',
    });

    await db.insert(AppStrings.statusTable, {
      'description': 'Para Ler',
    });
  }

  Future<void> listTables(Database db) async {
    try {
      final List<Map<String, dynamic>> tables = await db
          .rawQuery('SELECT name FROM sqlite_master WHERE type="table";');

      for (var table in tables) {
        log('Tabela: ${table['name']}');
      }
    } catch (e) {
      log("Erro ao listar tabelas: $e");
    }
  }

  Future<void> deleteDatabasew() async {
    final databasePath = join(await getDatabasesPath(), 'my_library.db');
    await deleteDatabase(databasePath);
  }
}
