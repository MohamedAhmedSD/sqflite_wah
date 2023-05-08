// build classes

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  // we need call it from any where => static
  static Database? _db;

  // this function will be return db
  Future<Database?> get db async {
    // condition to not recreate db which already founded
    if (_db == null) {
      // call this function => to create it
      _db = await intialDb();
      // we back our sb
      return _db;
    } else {
      return _db;
    }
  }

  // functions, future
  intialDb() async {
    // [1] path
    // where we save our database?
    // choose it automatically is better
    String databasepath = await getDatabasesPath(); // ex => btoo
    // connect our path to DB
    // join is bring DB path then add [/] to our path
    String path = join(databasepath, 'wael.db'); // btoo/wael.db

    // [2] function
    // create our DB, it need two args path and function
    // we add version & onUpgrade to update database because we cannot do that
    // due it create only once, instead of delete it
    // we call _onUpggrade automatically when edit version number
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 8, onUpgrade: _onUpgrade);
    return mydb;
  }

  // future function => 2 parameters (Database, int)
  // it call on first time only
//   _onCreate(Database db, int version) async {
//     // we excute our DB parameter
//     // AUTOINCREMENT => should be at end
//     // Table name != column name
//     // column name between "name"
//     await db.execute('''
//     CREATE TABLE "notes" (
//       "id" INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
//       "note" Text NOT NULL,
//     )

// ''');
// // Create => "table name" then columns
// // INTEGER , TEXT , REAL for 1.5
// // column:
// // name => type of its data => conditions,
// // we can make multiple tables
//     if (kDebugMode) {
//       print("Create database success ==============");
//     }
//   }

  // to add more than one table we need use batch rather than excute

  _onCreate(Database db, int version) async {
    // we excute our DB parameter
    // AUTOINCREMENT => should be at end
    // Table name != column name
    // column name between "name"

// make object from batch
// batch.execute => to make it easy add multitables
    Batch batch = db.batch();

// excute without await here to use await with commit
// don't forget => ,
    batch.execute('''
    CREATE TABLE "notes" (
      "id" INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
      "title" TEXT NOT NULL,
      "note" Text NOT NULL
    )
''');
// we add this line
    await batch.commit();
    if (kDebugMode) {
      print("Create database success b ==============");
    }
  }

  // onUpgrade, call only when we change
  _onUpgrade(Database db, int oldversion, int newversion) async {
    if (kDebugMode) {
      print('onUpgrade =========================');
    }
    // only use it once if repeat it make dupllicate table
    // await db.execute("ALTER TABLE notes ADD COLUMN color TEXT");
  }

// SELECT == read
// DELETE
// UPDATE
// INSERT

// raw => [Query,Insert,Update,Delete](sql)

// # ============ Four process ===========================
  readData(String sql) async {
    Database? mydb = await db; // db return from first function

    // to use SELECT, we add String parameter to be able use it
    // from out than inner place
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  // insert back int, value of row which added
  // if operation failed, it back 0, others main it call certain row
  insertData(String sql) async {
    Database? mydb = await db;

    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;

    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;

    int response = await mydb!.rawDelete(sql);
    return response;
  }

  // to delete all db data = clear
  // as intialDb to determain our path

  mydeleteDatabase() async {
    String dataBasePath = await getDatabasesPath();
    String path = join(dataBasePath, 'wael.db');
    // new
    await deleteDatabase(path);
  }

  //:::::::::: shourtcut methods ::::::::::::::::::::::::::
  // no need to write sql by yourself
  // usw query instead of rawQuery
  // it use table name instead of sql
  read(String table) async {
    Database? mydb = await db; // db return from first function

    // to use SELECT, we add String parameter to be able use it
    // from out than inner place
    List<Map> response = await mydb!.query(table);
    return response;
  }

  // insert back int, value of row which added
  // if operation failed, it back 0, others main it call certain row
  insert(
    String table,
    Map<String, Object?> values,
  ) async {
    Database? mydb = await db;

    int response = await mydb!.insert(table, values);
    return response;
  }

  // it need also where
  update(String table, Map<String, Object?> values, String? myWhere) async {
    Database? mydb = await db;

    int response = await mydb!.update(table, values, where: myWhere);
    return response;
  }

  delete(String table, String? myWhere) async {
    Database? mydb = await db;

    int response = await mydb!.delete(table, where: myWhere);
    return response;
  }
}
