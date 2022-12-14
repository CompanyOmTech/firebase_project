import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Screens/homepage.dart';

void main()async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initilization = Firebase.initializeApp();
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initilization,
        builder: (context, snapshort) {
          if (snapshort.hasError) {
            print('Somthing went wrong');
          }
          if (snapshort.connectionState == ConnectionState.done) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: MyHomePage(),
            );
          }
          return const CircularProgressIndicator();
        });
  }
}