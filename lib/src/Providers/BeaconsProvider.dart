import 'dart:async';
import 'package:ejemplocodec/src/models/beacons_models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mysql1/mysql1.dart';

class BeaconDbHelper {
  static const _databaseName = "beacons.db";
  static const _databaseVersion = 1;
  static const table = 'beacons';
  static const columnId = 'id';
  static const columnUuid = 'uuid';
  static const columnMajor = 'major';
  static const columnMinor = 'minor';
  static const columnRssi = 'rssi';
  static const ubicacion = 'ubicacion';

  // Singleton instance
  static final BeaconDbHelper instance = BeaconDbHelper._private();
  // Private constructor
  BeaconDbHelper._private();
  // Reference to the database
  late Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDb();
    return _database;
  }

  // Open the database
  _initDb() async {
    return await openDatabase(
      _databaseName,
      version: _databaseVersion,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnUuid TEXT NOT NULL,
            $columnMajor INTEGER NOT NULL,
            $columnMinor INTEGER NOT NULL,
            $columnRssi REAL NOT NULL,
            $ubicacion INT NOT NULL
          )
        ''');
      },
    );
  }

  // Insert a Beacon into the database
  Future<int> insert(Beacon beacon) async {
    var db = await database;
    return await db.insert(table, beacon.toMap());
  }

  // Read all Beacons from the database
  Future<List<Beacon>> readAll(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(table);

    return List.generate(maps.length, (i) {
      return Beacon(
        id: maps[i][columnId],
        uuid: maps[i][columnUuid],
        major: maps[i][columnMajor],
        minor: maps[i][columnMinor],
        rssi: maps[i][columnRssi],
        accuracy: maps[i][columnRssi],
      );
    });
  }

  Future<Beacon> read(int id) async {
    var db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      table,
      columns: [columnId, columnUuid, columnMajor, columnMinor, columnRssi],
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if (maps.length > 0) {
      return Beacon.fromMap(maps.first);
    }
    throw Exception("Beacon with id $id not found");
  }

// Update a Beacon in the database
  Future<void> update(Beacon beacon) async {
    final db = await database;
    await db.update(
      table,
      beacon.toMap(),
      where: '$columnId = ?',
      whereArgs: [beacon.id],
    );
  }
}

class ExternalDbHelper {
  final String host;
  final int port;
  final String database;
  final String user;
  final String password;

  ExternalDbHelper(
      {required this.host,
      required this.port,
      required this.database,
      required this.user,
      required this.password});

  Future<List<ResultRow>> selectData(String query) async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: host,
      port: port,
      db: database,
      user: user,
      password: password,
    ));

    final results = await conn.query(query);

    await conn.close();

    return results.toList();
  }

  Future<int?> insertData(Beacon beacon) async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: host,
      port: port,
      db: database,
      user: user,
      password: password,
    ));

    final result = await conn.query(
      'INSERT INTO beacons (id, uuid, major, minor, description) VALUES (?, ?, ?, ?, ?)',
      [beacon.id, beacon.uuid, beacon.major, beacon.minor],
    );

    await conn.close();

    return result.insertId;
  }
}
