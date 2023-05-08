// import 'package:flutter/material.dart';
// import 'package:sqflitenote/noteapp/edit.dart';

// import '../noteapp/sqldb.dart';

// // its local db, so need to use Futurebuilder , better use List
// class HomeAsList extends StatefulWidget {
//   const HomeAsList({Key? key}) : super(key: key);

//   @override
//   State<HomeAsList> createState() => _HomeAsListState();
// }

// class _HomeAsListState extends State<HomeAsList> {
//   // use our sqflite class or my package
//   SqlDb sqlDb = SqlDb();
//   bool isLoading = true;
//   // make empty list
//   List notes = [];

//   // Future<List<Map>> readData() async {
//   Future readData() async {
//     // for loading
//     // read by 2 ways
//     // [1] sql
//     // List<Map> response = await sqlDb.readData("SELECT * FROM notes");
//     // [2] query
//     List<Map> response = await sqlDb.read("notes");

//     // add this lines
//     //1
//     notes.addAll(response);
//     //2
//     isLoading = false;
//     //3
//     if (mounted) {
//       //4
//       setState(() {});
//     }
//     // we can delete return below
//     // return response; // this line solve nun-nullable our remove <generic from Future above>
//   }

//   // we need use init
//   @override
//   void initState() {
//     // call our function
//     readData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('HomePage'),
//       ),
//       // go to add notes page by FAB
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).pushNamed("addNotes");
//         },
//         child: const Icon(Icons.add),
//       ),
//       body: isLoading == true
//           ? const Center(
//               child: Text("is loading ..."),
//             )
//           : Container(
//               padding: const EdgeInsets.all(10),
//               child: ListView(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                 children: [
//                   // change FutureBuilder => ListView.builder
//                   // change snapshot.data! => by our list name == notes
//                   ListView.builder(
//                     itemCount: notes.length,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemBuilder: (context, i) {
//                       return Card(
//                         child: ListTile(
//                             // determain column name
//                             title: Text("${notes[i]['title']}"),
//                             subtitle: Text("${notes[i]['note']}"),
//                             // trailing: Text("${snapshot.data![i]['color']}"),
//                             // we use Row to use more than one icon
//                             // if not make => Row == min size => error of size
//                             trailing: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 IconButton(
//                                   onPressed: () async {
//                                     // we use id to delete certain row, not use "for column name"
//                                     //::::::::: id :::::: not use '' => not "id"
//                                     // how we reach to id number
//                                     // delete
//                                     //[1] sql
//                                     // 1:: from db
//                                     // int response = await sqlDb.deleteData(
//                                     //     "DELETE FROM 'notes' WHERE id = ${notes[i]['id']}");
//                                     // if (kDebugMode) {
//                                     //   print("$response");
//                                     // } // 0 => failed , others => it works and indicate to certain row
//                                     // 2:: from UI

//                                     // [2] id not as we use on edit
//                                     // :::::::::::: becarful ::::::::::::::::
//                                     int response = await sqlDb.delete(
//                                         "notes", "id = ${notes[i]['id']}");
//                                     if (response > 0) {
//                                       // to update data immediatlly
//                                       //1
//                                       notes.removeWhere((element) =>
//                                           element['id'] == notes[i]['id']);
//                                       //2
//                                       setState(() {});
//                                     }
//                                   },
//                                   icon: const Icon(
//                                     Icons.delete,
//                                     color: Colors.red,
//                                   ),
//                                 ),
//                                 // edit :::::::::::
//                                 // open my note details
//                                 // try change color as that you enter
//                                 IconButton(
//                                     onPressed: () async {
//                                       // nav with pass data
//                                       Navigator.of(context)
//                                           .push(MaterialPageRoute(
//                                               builder: (c) => EditNotes(
//                                                     color: notes[i]['color'],
//                                                     note: notes[i]['note'],
//                                                     title: notes[i]['title'],
//                                                     id: notes[i]['id'],
//                                                   )));
//                                     },
//                                     icon: const Icon(
//                                       Icons.edit,
//                                       color: Colors.blue,
//                                     )),
//                               ],
//                             )),
//                       );
//                     },
//                   ),
//                   const SizedBox(
//                     height: 16,
//                   ),
//                   Center(
//                     child: MaterialButton(
//                       // future
//                       onPressed: () async {
//                         await sqlDb.mydeleteDatabase();
//                       },
//                       color: Colors.red,
//                       textColor: Colors.white,
//                       child: const Text('Delete all data'),
//                     ),
//                   ), // button to delete database
//                 ],
//               ),
//             ),
//     );
//   }
// }
