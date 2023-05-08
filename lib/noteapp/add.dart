import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../noteapp/sqldb.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({Key? key}) : super(key: key);

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  //* we need db + form => [key + TFF]
  // call db
  SqlDb sqlDb = SqlDb();
  // key
  GlobalKey<FormState> formState = GlobalKey();
  // controller
  TextEditingController note = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController color = TextEditingController();

  @override
  void initState() {
    //* for controller
    note;
    title;
    color;
    super.initState();
  }

  @override
  void dispose() {
    //* for controller
    note;
    title;
    color;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Notes'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(children: [
          Form(
            key: formState,
            child: Column(
              children: [
                //?=========== title, note, color TFF =================
                TextFormField(
                  controller: title,
                  decoration: const InputDecoration(hintText: 'title'),
                ),
                TextFormField(
                  controller: note,
                  decoration: const InputDecoration(hintText: 'note'),
                ),
                TextFormField(
                  controller: color,
                  decoration: const InputDecoration(hintText: 'color'),
                ),

                Container(
                  height: 20,
                ),
                //? ====== btn => [ insert + nav after that to home page] ==
                //* how we assign value from TFF unto local DB ============
                MaterialButton(
                  /*
                          INSERT INTO notes (`cn` , `cn`, `cn`)
                          VALUES ("${cn.dt}","${cn.dt}","${cn.dt}")
                    */
                  onPressed: () async {
                    // '''
                    //     INSERT INTO notes (`note` , `title`, `color`)
                    //     VALUES ("${note.text}","${title.text}","${color.text}")
                    //     ''');
                    //? [1] sql
                    // int response = await sqlDb.insertData('''
                    //     INSERT INTO notes ('note' , 'title', 'color')
                    //     VALUES ("${note.text}","${title.text}","${color.text}")
                    //     ''');
                    //? [2] query , table == [map{"key":"value"}]
                    int response = await sqlDb.insert("notes", {
                      // data as map
                      "note": note.text,
                      "title": title.text,
                      "color": color.text,
                    });
                    //? why we save our sql or query into var respnse??
                    //! to use respose value to check if operation done or failed
                    //* if add success back to Home page=====
                    //* if not => don't do any thing=========
                    if (response > 0) {
                      if (kDebugMode) {
                        print(response);
                      }

                      //!====== how we nav ===========
                      if (!mounted) return;
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('home', (route) => false);
                    } else {
                      if (kDebugMode) {
                        print("failed");
                      }
                    }
                  },
                  child: const Text('Add Note'),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
