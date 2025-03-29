import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class Transaction{
  int id;
  int amount;
  String date;    
  String credit;
  String type;
  String note;
  Transaction(
    this.id,
    this.amount,
    this.date,
    this.credit,
    this.type,
    this.note,
  );
  Map<String, dynamic> toMap(){
  return{
    'id': id,
    'amount': amount,
    'date': date,
    'credit': credit,
    'type': type,
    'note': note,
  };
}
Transaction.fromMap(Map<String, dynamic> map)
: id = map['id'],amount = map['amount'], date = map['date'], credit = map['credit'], type = map['type'], note = map['note']; 

}

class DatabaseService {
  // Singleton instance
  static final DatabaseService instance = DatabaseService._constructor();
  static Database? _db;
  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  // Table name
  final String _tablename = "transactions";

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "transactions.db");

    final database = await openDatabase(
      databasePath,
      version: 1, // Version is required
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE $_tablename (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount INTEGER NOT NULL,
            date TEXT,
            credit TEXT,
            type TEXT,
            note TEXT
          ) 
          '''
        );
      },
    );

    return database;
  }
  void addTransaction(int amount, DateTime date, bool credit, String type, String note) async{
    final db = await database; // defining map
    await db.insert("transactions", {
      "amount": amount,
      "date": date.toString(),
      "credit": credit ? "Credit": "Debit",
      "type": type,
      "note": note,
    });
  } 
  
  Future<List<Transaction>> getTransactions() async{
    final db = await database;
    final List<Map<String, dynamic>> data = await db.query("transactions");
    return data.map((map) => Transaction.fromMap(map)).toList();
  }
}
