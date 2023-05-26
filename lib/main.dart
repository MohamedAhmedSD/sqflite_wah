import 'package:flutter/material.dart';
import 'package:sqflitenote/noteapp/edit.dart';

import 'basic/baisc.dart';
import 'noteapp/add.dart';
import 'noteapp/home.dart';
// import 'noteapp/home.dart';

//* async => deal with local DB
void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sqflite Course',
      initialRoute: 'basic',
      routes: {
        'basic': (context) => const Basic(),
        'home': (context) => const Home(),
        'addNotes': (context) => const AddNotes(),
        'editNotes': (context) => const EditNotes(),
        // 'home': (context) => const HomeAsList(),
      },
    );
  }
}
