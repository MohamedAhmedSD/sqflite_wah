import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../basic/sqldb.dart'; // look

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //! === to build future function that used inside our FutureBuilder =======
  //* [1] use our sqflite class or my package
  SqlDb sqlDb = SqlDb();

  //* [2] read future data => only return List others back int ::::::::::::::::
  // we write data type we deal with it
  Future<List<Map>> readData() async {
    List<Map> response = await sqlDb.readData("SELECT * FROM notes");
    return response; // this line solve nun-nullable
  }

  //? we can use empty list and add data on it, with call them inside init state
  //* or just use future builder

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
      ),
      // go to add notes page by FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("addNotes");
        },
        child: const Icon(Icons.add),
      ),
      //! ==== LV => FB => LV.builder() =========
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        children: [
          //? ============== basic =========================================
          //! when use future builder no need to empty list to add data on it==
          FutureBuilder(
              future: readData(),

              //* determain our datatype & use AsyncSnapshot to avoid errors
              //? we read data so data type == List<Map>
              builder:
                  (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
                if (snapshot.hasData) {
                  //* check
                  if (kDebugMode) {
                    print("data");
                  }
                  //* ================ build our list =====================
                  return ListView.builder(
                      //?====================================================
                      //! === data == List<Map<dynamic, dynamic>>? data ====
                      //?====================================================
                      itemCount: snapshot.data!.length,
                      //? two list in same place :::::::
                      //* we must use => physics && shrinkWrap
                      //* to control scroll
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        //* ========= to see all data ===========
                        // access to our data with snapshot
                        // return Text('${snapshot.data![i]}');
                        //* use column names of table =========
                        return Card(
                          child: ListTile(
                            // determain column name
                            title: Text("${snapshot.data![i]['title']}"),
                            subtitle: Text("${snapshot.data![i]['note']}"),
                            // trailing: Text("${snapshot.data![i]['color']}"),
                            //?================ delete certain note ==============
                            trailing:
                                //* [delete only]
                                // IconButton(
                                //   onPressed: () async {
                                //     //* we use id to delete certain row, not use "for column name"
                                //     //* how we reach to id number
                                //     int response = await sqlDb.deleteData(
                                //         "DELETE FROM 'notes' WHERE id = ${snapshot.data![i]['id']}");
                                //     if (kDebugMode) {
                                //       print("$response");
                                //     }
                                //     //* to update UI after it
                                //     setState(() {});
                                //   },
                                //   icon: const Icon(
                                //     Icons.delete,
                                //     color: Colors.red,
                                //   ),
                                // ),
                                //* [Delete and Edit]
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              //? ===[Edit] ======
                              //! how I nav into edit page which need notes id ===
                              //!============================================
                              IconButton(
                                onPressed: () async {
                                  Navigator.of(context)
                                      .pushNamed("editNotes", arguments: "1");
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.update,
                                  color: Colors.red,
                                ),
                              ),
                              //? ===[delete] ======
                              IconButton(
                                onPressed: () async {
                                  //* we use id to delete certain row, not use "for column name"
                                  //* how we reach to id number
                                  int response = await sqlDb.deleteData(
                                      "DELETE FROM 'notes' WHERE id = ${snapshot.data![i]['id']}");
                                  if (kDebugMode) {
                                    print("$response");
                                  }
                                  //* to update UI after it
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ]),
                          ),
                        );
                      });
                }
                //* should be used to wait during loading ==============
                return const Center(child: CircularProgressIndicator());
              }), // button to delete database
          const SizedBox(
            height: 20,
          ),
          //? =================== how use other functions ====================
          //* ===== [1] INSERT =====
          Center(
            child: MaterialButton(
              // future
              onPressed: () async {
                // id increase automatically so we not write it on insert
                int response = await sqlDb.insertData(
                    "INSERT INTO 'notes' ('note','title','color') VALUES ('note one','jjj','red')");
                if (kDebugMode) {
                  print(response);
                } // 0 => failed , others num => it works and indicate to certain row
                //* to update UI after it
                setState(() {});
              },
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('Insert Data'),
            ),
          ),
          //* ===== [2] SELECT =====
          Center(
            child: MaterialButton(
              onPressed: () async {
                // we back List<Map>
                List<Map> response =
                    await sqlDb.readData("SELECT * FROM 'notes'");
                // we print Strings
                if (kDebugMode) {
                  print('$response');
                }
                //* to update UI after it
                setState(() {});
              },
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('Read Data'),
            ),
          ),
          //* ===== [3] DELETE id 3 =====
          Center(
            child: MaterialButton(
              // future
              onPressed: () async {
                // we use id to delete certain row, not use "for column name"
                //::::::::: id :::::: not use '' => not "id"
                int response =
                    await sqlDb.deleteData("DELETE FROM 'notes' WHERE id = 3");
                if (kDebugMode) {
                  print("$response");
                } // 0 => failed , others => it works and indicate to certain row
                //* to update UI after it
                setState(() {});
              },
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('Delete Data'),
            ),
          ),
          //* ===== [4] UPDATE =====
          Center(
            child: MaterialButton(
              // future
              onPressed: () async {
                // we use id to delete certain row, not use "for column name"
                int response = await sqlDb.updateData(
                    "UPDATE 'notes' SET 'note' = 'note six' WHERE id = 1");
                if (kDebugMode) {
                  print("$response");
                } // 0 => failed , others => it works and indicate to certain row
                //* to update UI after it
                setState(() {});
              },
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('Update Data'),
            ),
          ),
          //* ===== [5] DELETE ALL DB =====
          Center(
            child: MaterialButton(
              // future
              onPressed: () async {
                // we use id to delete certain row, not use "for column name"
                await sqlDb.mydeleteDatabase();
                // error if make response -- int
                // var response = await sqlDb.mydeleteDatabase();
                // if (kDebugMode) {
                //   print("$response");
                // }
                //* to update UI after it
                setState(() {});
                //! ===== error exit from app =========
                //? Exception has occurred.
                //? SqfliteDatabaseException (DatabaseException(database_closed 3))
                //* :::::::: nav to certain page or create new DB :::::::::::
                //? [a] not work
                // if (!mounted) return;
                // Navigator.of(context)
                //     .pushNamedAndRemoveUntil('basic', (route) => false);
                //? [b] not work
                // await sqlDb.intialDb();
              },
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('Delete all Data'),
            ),
          ),
          //* ===== [6] intialDb =====
          Center(
            child: MaterialButton(
              // future
              onPressed: () async {
                //! we delete _ privit from it
                //* and call inside it all privit function
                await sqlDb.intialDb();
                //* to update UI after it
                setState(() {});
              },
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('start Data'),
            ),
          ),
          //* ===== [7] upgrade =====
          // Center(
          //   child: MaterialButton(
          //     // future
          //     onPressed: () async {
          //       //! onUpgrade => privit => use getter
          //       //* make getter to it
          //       await sqlDb.db;

          //     },
          //     color: Colors.red,
          //     textColor: Colors.white,
          //     child: const Text('start Data'),
          //   ),
          // ),
        ],
      ),
    );
  }
}
