import 'package:flutter/material.dart';

import 'sqldb.dart';

class Basic extends StatefulWidget {
  const Basic({Key? key}) : super(key: key);

  @override
  State<Basic> createState() => _BasicState();
}

class _BasicState extends State<Basic> {
  //****************************************************************************
  //* use our sqflite class or my package,
  //? we create instance from object

  SqlDb sqlDb = SqlDb();

  @override
  void initState() {
    //! call date base on start to create db automatically
    //* we deal with privit && getter don't forget how we reach them
    sqlDb.db;
    super.initState();
  }

  //****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Sqflite Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            //? ========================= [ 1.INSERT] ==========================
            child: MaterialButton(
              // future
              onPressed: () async {
                //! id increase automatically so we not write it on insert
                int response = await sqlDb.insertData(
                    //! [* error *]
                    //? no way to insert element less than number of columns
                    // "INSERT INTO 'notes' ('note') VALUES ('note one')");
                    //? if our number of columns write we may add empty values
                    "INSERT INTO 'notes' ('note','title','color') VALUES ('note one','','')");

                //! how I call new table after upgrade db, we see old not affect

                //? old 3 new 4 => when use insert only 3 no error

                // "INSERT INTO 'notes' ('note','title','color','newcolor')
                // VALUES ('note one','','','')");
                //* 0 => failed , others num => it works and indicate to certain row
                print(response);
              },
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('Insert Data'),
            ),
          ),
          Center(
            //? =========================== [ 2. SELECT] ======================
            child: MaterialButton(
              onPressed: () async {
                // we back List<Map>
                List<Map> response =
                    await sqlDb.readData("SELECT * FROM 'notes'");
                // we print Strings
                print('$response');
              },
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('Read Data'),
            ),
          ),
          Center(
            //? =========================== [ 3. UPDATE] ======================
            child: MaterialButton(
              // future
              onPressed: () async {
                // we use id to delete certain row, not use "for column name"
                int response = await sqlDb.updateData(
                    "UPDATE 'notes' SET 'note' = 'note six' WHERE id = 2");
                //* 0 => failed , 1 => it works and updated the row
                print("$response");
              },
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('Update Data'),
            ),
          ),
          Center(
            //? =========================== [ 4. DELETE] ======================
            //! when delete certain ID not used again by DB ================
            child: MaterialButton(
              // future
              onPressed: () async {
                //! we use id to delete certain row, not use "for column name"
                //!::::::::: id :::::: not use '' => not "id"

                //* but use => id = 3 => INT

                int response =
                    await sqlDb.deleteData("DELETE FROM 'notes' WHERE id = 2");
                //* 0 => failed , 1 => it works and delete row
                print("$response");
              },
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('Delete Data'),
            ),
          ),
          Center(
            //? ==================== [ 4. DELETE all DB ] ======================
            child: MaterialButton(
              // future
              onPressed: () async {
                await sqlDb.mydeleteDatabase();
                //* 0 => failed , others => it works and indicate to certain row
                print("Data base it deleted");
              },
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('Delete all db'),
            ),
          ),
        ],
      ),
    );
  }
}
