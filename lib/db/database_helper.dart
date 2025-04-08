import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/blood_bank.dart';
import '../models/donor.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'blood_bank.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE donors (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        bloodGroup TEXT NOT NULL,
        contact TEXT NOT NULL,
        location TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE BloodBank (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        location TEXT NOT NULL,
        contact TEXT NOT NULL
      )
    ''');

    await db.execute('''
    CREATE TABLE BloodRequest (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      bloodGroup TEXT NOT NULL,
      contact TEXT NOT NULL,
      location TEXT NOT NULL,
      status TEXT DEFAULT 'Pending'
    )
  ''');
  }

  // **Donor CRUD operations**
  Future<int> addDonor(Donor donor) async {
    final db = await instance.database;
    return await db.insert('donors', donor.toMap());
  }

  Future<List<Donor>> getAllDonors() async {
    final db = await instance.database;
    final result = await db.query('donors');
    return result.map((json) => Donor.fromMap(json)).toList();
  }

  Future<int> updateDonor(Donor donor) async {
    final db = await instance.database;
    return await db.update(
      'donors',
      donor.toMap(),
      where: 'id = ?',
      whereArgs: [donor.id],
    );
  }

  Future<int> deleteDonor(int id) async {
    final db = await instance.database;
    return await db.delete(
      'donors',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // **Blood Bank CRUD operations**
  Future<int> insertBloodBank(BloodBank bank) async {
    try {
      final db = await instance.database;
      int result = await db.insert("BloodBank", bank.toMap());

      if (result > 0) {
        print("✅ Blood Bank added successfully: ID $result");
      } else {
        print("Failed to add Blood Bank.");
      }

      return result;
    } catch (e) {
      print("Error inserting blood bank: $e");
      return 0;
    }
  }


  Future<List<BloodBank>> getAllBloodBanks() async {
    final db = await instance.database;
    final result = await db.query("BloodBank");
    return result.map((map) => BloodBank.fromMap(map)).toList();
  }

  Future<int> updateBloodBank(BloodBank bank) async {
    final db = await instance.database;
    return await db.update(
      "BloodBank",
      bank.toMap(),
      where: "id = ?",
      whereArgs: [bank.id],
    );
  }

  Future<int> deleteBloodBank(int id) async {
    final db = await instance.database;
    return await db.delete(
      "BloodBank",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // Insert Blood Request
  Future<int> insertBloodRequest(Map<String, dynamic> request) async {
    final db = await instance.database;
    return await db.insert("BloodRequest", request);
  }

// Get All Blood Requests (For Admin)
  Future<List<Map<String, dynamic>>> getAllBloodRequests() async {
    final db = await instance.database;
    return await db.query("BloodRequest");
  }

  Future<int> updateBloodRequestStatus(int id, String status) async {
    final db = await instance.database;
    return await db.update(
      "BloodRequest",
      {"status": status},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getUserBloodRequests(String contact) async {
    final db = await instance.database;
    return await db.query(
      "BloodRequest",
      where: "contact = ?",
      whereArgs: [contact],
    );
  }

  // **Close Database**
  Future<void> closeDatabase() async {
    final db = await instance.database;
    db.close();
  }



  
}
