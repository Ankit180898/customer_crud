import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'customer_crud.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE customer (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pan TEXT NOT NULL,
        full_name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE address (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER NOT NULL,
        address_line1 TEXT NOT NULL,
        address_line2 TEXT,
        postcode TEXT NOT NULL,
        state TEXT NOT NULL,
        city TEXT NOT NULL,
        FOREIGN KEY (customer_id) REFERENCES customer (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertCustomer(Map<String, dynamic> customer) async {
    final db = await database;
    return await db.insert('customer', customer);
  }

  Future<int> insertAddress(Map<String, dynamic> address) async {
    final db = await database;
    return await db.insert('address', address);
  }

  Future<List<Map<String, dynamic>>> getCustomers() async {
    final db = await database;
    return await db.query('customer');
  }

  Future<List<Map<String, dynamic>>> getAddresses(int customerId) async {
    final db = await database;
    return await db.query('address', where: 'customer_id = ?', whereArgs: [customerId]);
  }

  Future<int> updateCustomer(Map<String, dynamic> customer) async {
    final db = await database;
    return await db.update(
      'customer',
      customer,
      where: 'id = ?',
      whereArgs: [customer['id']],
    );
  }

  Future<int> updateAddress(Map<String, dynamic> address) async {
    final db = await database;
    return await db.update(
      'address',
      address,
      where: 'id = ?',
      whereArgs: [address['id']],
    );
  }

  Future<void> deleteCustomer(int id) async {
    final db = await database;
    await db.delete(
      'customer',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAddress(int id) async {
    final db = await database;
    await db.delete(
      'address',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
