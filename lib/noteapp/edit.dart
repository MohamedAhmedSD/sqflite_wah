// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../noteapp/sqldb.dart';

class EditNotes extends StatefulWidget {
  // we need pass data
  // as Strings or List
  final note;
  final title;
  final color;
  final id;

  // final String note;
  // final String title;
  // final String color;
  // final int id;
  const EditNotes({
    Key? key,
    this.note,
    this.title,
    this.color,
    this.id,
  }) : super(key: key);

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
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
    note.text = widget.note;

    /// Retrieve the value of the "title" property from the "widget" object.
    title.text = widget.title;
    color.text = widget.color;
    super.initState();
  }

  // @override
  // void dispose() {
  //   note;
  //   title;
  //   color;
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Notes'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(children: [
          Form(
              key: formState,
              child: Column(
                children: [
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
                  //
                  Container(
                    height: 20,
                  ),
                  MaterialButton(
                    /*
                          INSERT INTO notes (`cn` , `cn`, `cn`)
                          VALUES ("${cn.dt}","${cn.dt}","${cn.dt}")
                    */
                    onPressed: () async {
                      // [1] sql
                      // int response = await sqlDb.updateData('''
                      //     UPDATE notes SET
                      //     note = "${note.text}",
                      //     title = "${title.text}",
                      //     color = "${color.text}"
                      //     WHERE id = ${widget.id}
                      //     ''');

                      // [2] table, query
                      // where => "id = ${widget.id}"
                      int response = await sqlDb.update(
                          "notes",
                          {
                            "note": note.text,
                            "title": title.text,
                            "color": color.text,
                            // "color":"${color.text}"
                          },
                          "id = ${widget.id}");

                      if (response > 0) {
                        setState(() {});
                        if (!mounted) return;
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('home', (route) => false);
                      }
                    },
                    child: const Text('Edit Note'),
                  )
                ],
              ))
        ]),
      ),
    );
  }
}
