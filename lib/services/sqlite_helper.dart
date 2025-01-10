import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteHelper {
  static const String _dbName = 'app_data.db';
  static const int _dbVersion = 1;

  // Tabel Users
  static const String tableUsers = 'users';
  static const String columnUserId = 'userId';
  static const String columnUsername = 'username';
  static const String columnEmail = 'email';

  // Tabel Menus
  static const String tableMenus = 'menus';
  static const String columnMenuId = 'menuId';
  static const String columnMenuName = 'name';
  static const String columnMenuDescription = 'description';
  static const String columnMenuPrice = 'price';

  // Tabel Transactions
  static const String tableTransactions = 'transactions';
  static const String columnTransactionId = 'transactionId';
  static const String columnTransactionUserId = 'userId';
  static const String columnTransactionItems = 'items';
  static const String columnTransactionTotalPrice = 'totalPrice';
  static const String columnTransactionStatus = 'status';
  static const String columnTransactionTimestamp = 'timestamp';

  SQLiteHelper._privateConstructor();
  static final SQLiteHelper instance = SQLiteHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Membuat tabel Users
    await db.execute('''
      CREATE TABLE $tableUsers (
        $columnUserId TEXT PRIMARY KEY,
        $columnUsername TEXT NOT NULL,
        $columnEmail TEXT NOT NULL
      )
    ''');

    // Membuat tabel Menus
    await db.execute('''
      CREATE TABLE $tableMenus (
        $columnMenuId TEXT PRIMARY KEY,
        $columnMenuName TEXT NOT NULL,
        $columnMenuDescription TEXT,
        $columnMenuPrice REAL NOT NULL
      )
    ''');

    // Membuat tabel Transactions
    await db.execute('''
      CREATE TABLE $tableTransactions (
        $columnTransactionId TEXT PRIMARY KEY,
        $columnTransactionUserId TEXT NOT NULL,
        $columnTransactionItems TEXT NOT NULL,
        $columnTransactionTotalPrice REAL NOT NULL,
        $columnTransactionStatus TEXT NOT NULL,
        $columnTransactionTimestamp TEXT NOT NULL
      )
    ''');
  }

  // Metode CRUD
  Future<void> insertUser(String userId, String username, String email) async {
    Database db = await database;
    await db.insert(
      tableUsers,
      {
        columnUserId: userId,
        columnUsername: username,
        columnEmail: email,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUser(String userId) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      tableUsers,
      where: '$columnUserId = ?',
      whereArgs: [userId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> insertMenu(String menuId, String name, String description, double price) async {
    Database db = await database;
    await db.insert(
      tableMenus,
      {
        columnMenuId: menuId,
        columnMenuName: name,
        columnMenuDescription: description,
        columnMenuPrice: price,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getMenus() async {
    Database db = await database;
    return await db.query(tableMenus);
  }

  Future<void> updateMenu(String menuId, String name, String description, double price) async {
    Database db = await database;
    await db.update(
      tableMenus,
      {
        columnMenuName: name,
        columnMenuDescription: description,
        columnMenuPrice: price,
      },
      where: '$columnMenuId = ?',
      whereArgs: [menuId],
    );
  }

  Future<void> deleteMenu(String menuId) async {
    Database db = await database;
    await db.delete(
      tableMenus,
      where: '$columnMenuId = ?',
      whereArgs: [menuId],
    );
  }

  Future<void> insertTransaction(String transactionId, String userId, String items,
      double totalPrice, String status, String timestamp) async {
    Database db = await database;
    await db.insert(
      tableTransactions,
      {
        columnTransactionId: transactionId,
        columnTransactionUserId: userId,
        columnTransactionItems: items,
        columnTransactionTotalPrice: totalPrice,
        columnTransactionStatus: status,
        columnTransactionTimestamp: timestamp,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getTransactions(String userId) async {
    Database db = await database;
    return await db.query(
      tableTransactions,
      where: '$columnTransactionUserId = ?',
      whereArgs: [userId],
    );
  }
}
