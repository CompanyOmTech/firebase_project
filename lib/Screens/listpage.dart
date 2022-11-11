import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/Screens/editpage.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final Stream<QuerySnapshot> profilename =
      FirebaseFirestore.instance.collection('users').snapshots();

  CollectionReference students = FirebaseFirestore.instance.collection('users');

  Future<void> deleteUser(id) {
    return students
        .doc(id)
        .delete()
        .then((value) => print('User Deleted'))
        .catchError((error) => print('Failed to Delete user: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: profilename,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshort) {
        if (snapshort.hasError) {
          print('Somethinfg went worng');
        }
        if (snapshort.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final List storedocs = [];
        snapshort.data!.docs.map(
          (DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            storedocs.add(a);
            a['id'] = document.id;
          },
        ).toList();

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Table(
              border: TableBorder.all(),
              columnWidths: const <int, TableColumnWidth>{
                1: FixedColumnWidth(140),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        color: Colors.greenAccent,
                        child: const Center(
                          child: Text(
                            'Firstname',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        color: Colors.greenAccent,
                        child: const Center(
                          child: Text(
                            'lastname',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        color: Colors.greenAccent,
                        child: const Center(
                          child: Text(
                            'Action',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                for (var i = 0; i < storedocs.length; i++) ...[
                  TableRow(
                    children: [
                      TableCell(
                        child: Center(
                          child: Text(
                            storedocs[i]['firstname'].toString(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Center(
                          child: Text(
                            storedocs[i]['lastname'],
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditPage(
                                      id: storedocs[i]['id'],
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                                onPressed: () {
                                  deleteUser(storedocs[i]['id']);
                                },
                                icon: const Icon(Icons.delete))
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
