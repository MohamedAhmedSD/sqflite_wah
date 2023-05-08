import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

//! =============== build classes ==============

//* our model
class SqlDb {
  //* we need call it from any where => static == it class attribute
  //* => no need to make an object to call it, just access through class name

  //? Database to send sql commands, created during [openDatabase]
  static Database? _db; //! privit => need getter to deal with it

  //! [1]===== method to check if there db or not with same name ============
  //!========================================================================
  //* this function will be return db
  //* it getter method that back => Future<Database?>
  //? and because we deal with Future => we need use async && await
  Future<Database?> get db async {
    //* ====== [condition to not recreate db which already founded] =========
    if (_db == null) {
      //? if db not created, make it

      //* call this function => to create it
      _db = await intialDb();

      //* then, we back our db
      return _db;
    } else {
      //? if there db with same name, just return it
      return _db;
    }
  }

  //! ===================== [2] to create new db ======================
  //!========================================================================
  //* functions, future => start point
  intialDb() async {
    //* [1] path
    //? where we save our database?
    //! choose it automatically is better => by built-in =>
    //* => getDatabasesPath()

    String databasepath = await getDatabasesPath(); //* ex => btoo

    //* [2] full path
    //? connect our path to DB
    //* join is bring DB path then add [/] to our path
    //! must end with .db
    //* join => add / that we need them
    String path = join(databasepath, 'wael.db'); //* btoo/wael.db

    //* [3] function => create our DB, built-in => openDatabase
    //? openDatabase => it need two args (path and functions)
    //* we add version & onUpgrade to update database because we cannot do that
    //? due to it create only once, instead of delete it
    //* we call _onUpggrade automatically when edit version number

    Database mydb = await openDatabase(path,
        //* onCreate need 2 args, we make it alone function bellow
        onCreate: _onCreate,
        //* we need version && onUpgrade => to make possible change db structure
        version: 200,
        onUpgrade: _onUpgrade);
    //! don't forget return db =======================================
    return mydb;
  }

  //! ===================== [3] _onCreate ======================
  //!========================================================================
  //* {FutureOr<void> Function(Database, int)? onCreate}
  // future function => 2 parameters (Database, int)
  //? it call on first time only
  //! we need it to create tables
  //* it future function here

  _onCreate(Database db, int version) async {
    //* we excute our sql code through DB parameter

    //? AUTOINCREMENT => should be at end
    //! Table name != column name [don't use same name for table && column]
    //? put table && column name between ''

    //! table 1 :::::::::::::::::::::::::::::::
    //? Execute an SQL query with no return value.

    await db.execute('''
    CREATE TABLE "notes" (
      "id" INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
      "note" Text NOT NULL,
      "title" TEXT NOT NULL,
      "color" Text NOT NULL
    )

''');

//? Create => "table name" then columns
// TEXT == VARCHAR, REAL == DOUBLE == FLOAT
// INTEGER , TEXT , REAL for 1.5
//? column:
//* name => type of its data => conditions,
//! ------------- we can make multible tables ----------

//! table 2 :::::::::::::::::::::::::::::::
//     await db.execute('''
//     CREATE TABLE "users" (
//       "id" INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
//       "user" Text NOT NULL
//     )

// ''');

    if (kDebugMode) {
      print("Create database success ==============");
    }
  }

  //* to add more than one table we need use batch rather than excute
  _onCreateWithBatch(Database db, int version) async {
    //* make an object from batch that access through db
    //? batch.execute => to make it easy add multitables

    Batch batch = db.batch();

    //! excute without await here to use await with commit
    //* don't forget => ,

    batch.execute('''
    CREATE TABLE "notes" (
      "id" INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
      "title" TEXT NOT NULL,
      "note" Text NOT NULL
    )
  ''');

    //! we add this line to apply modify
    await batch.commit();
    if (kDebugMode) {
      print("Create database success batch updated ==============");
    }
  }

  //! ===================== [4] _onUpgrade ======================
  //!========================================================================
  // onUpgrade
  _onUpgrade(Database db, int oldversion, int newversion) async {
    if (kDebugMode) {
      print('onUpgrade =========================');
    }
    //! only use it once if repeat it make dupllicate table
    await db.execute("ALTER TABLE notes ADD COLUMN newcolor TEXT");
    //! I add table but not make error on old columns =>
    //* old 3 new 4 => when use insert only 3 no error
  }

  //! ============================= [5] CRUD ================================
  //!========================================================================
  // SELECT == read
  // DELETE
  // UPDATE
  // INSERT
  //* we need deal with DataBase => so bring that db, that return from
  //? get db function above
  //* we deal with row => throghu sql instructions
  //! raw => [Query,Insert,Update,Delete](sql)

  //* # ============ Four process ===========================
  //?===== [1]============
  readData(String sql) async {
    Database? mydb = await db; //* db return from first function

    //! to use SELECT, we add String parameter to be able use it
    //* from out than inner place, so by using paramater may
    //* write alot of sql codes

    //! ==========method not work with null==========
    List<Map> response = await mydb!.rawQuery(sql);
    // List<Map> list = await database.rawQuery('SELECT * FROM Test');

    //! don't forget return
    return response;
  }

  //?===== [2]============
  //* insert back int, value of row which added
  //* if operation failed, it back 0, others main it call certain row

  insertData(String sql) async {
    Database? mydb = await db;
    // method not work with null
    int response = await mydb!.rawInsert(sql);

    /// int id1 = await database.rawInsert(
    /// 'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
    return response;
  }

  //?===== [3]============
  updateData(String sql) async {
    Database? mydb = await db;

    int response = await mydb!.rawUpdate(sql);

    ///int count = await database.rawUpdate(
    ///'UPDATE Test SET name = ?, value = ? WHERE name = ?',
    ///['updated name', '9876', 'some name']);
    return response;
  }

  //?===== [4 => A]============
  //! when delete certain ID not used again by DB ================
  deleteData(String sql) async {
    Database? mydb = await db;

    int response = await mydb!.rawDelete(sql);

    /// int count = await database.rawDelete(
    /// 'DELETE FROM Test WHERE name = ?', ['another name']);
    return response;
  }

  // to delete all db data = clear
  // as intialDb to determain our path
  //?===== [4 => B]============
  mydeleteDatabase() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'wael.db');
    // new
    await deleteDatabase(path);
  }
  //* CRUD summary::::::::::::
  //? it use db to access row methods
  //* row methods 3 back int and one back List<Map>
  //* to delete all db we need its path then use built-in => deleteDatabase(path)

  //?===========================================================
  //!:::::::::: shourtcut methods ::::::::::::::::::::::::::
  //?===========================================================
  //* no need to write sql by yourself
  //! use query instead of rawQuery
  //? it use table name instead of sql, it back same data type
  //* same to way we use on rowmethod(sql) => query(table)

  //?===== [1]============
  read(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  //* insert and update => need values that we add to table
  //! Map<String, Object?> values
  //?===== [2]============
  insert(
    String table,
    Map<String, Object?> values,
  ) async {
    Database? mydb = await db;

    int response = await mydb!.insert(table, values);
    return response;
  }

  //?===== [3]============
  //* Update need also where == [condition must be true to modify]
  update(String table, Map<String, Object?> values, String? myWhere) async {
    Database? mydb = await db;

    int response = await mydb!.update(table, values, where: myWhere);
    return response;
  }

  //?===== [4]============
  //* delete need where also => [condition must be true to modify]
  delete(String table, String? myWhere) async {
    Database? mydb = await db;

    int response = await mydb!.delete(table, where: myWhere);
    return response;
  }
}