import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  final String id;

  const EditPage({Key? key, required this.id}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
//Upadating Student
  CollectionReference students = FirebaseFirestore.instance.collection('users');
  Future<void> updateUser(id, fname, lname) {
    print("--------${id}");
    return students
        .doc(id)
        .update({'firstname': fname, 'lastname': lname})
        .then((value) => print('User Update'))
        .catchError((error) => pragma('Failed to update user:$error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
      ),
      body: Form(
          key: _formKey,

          //Getting Specific Data By ID
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.id)
                .get(),
            builder: (_, snapshort) {
              if (snapshort.hasError) {
                print('Something went wrong');
              }
              if (snapshort.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              var data = snapshort.data!.data();
              var fname = data!['firstname'];
              var lname = data['lastname'];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        initialValue: fname,
                        autofocus: false,
                        onChanged: (value) => fname = value,
                        decoration: const InputDecoration(
                            labelText: 'Firstname',
                            labelStyle: TextStyle(
                              fontSize: 20,
                            ),
                            border: OutlineInputBorder(),
                            errorStyle:
                                TextStyle(color: Colors.red, fontSize: 15)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Firstname';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        initialValue: lname,
                        autofocus: false,
                        onChanged: (value) => lname = value,
                        decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              fontSize: 20,
                            ),
                            border: OutlineInputBorder(),
                            errorStyle:
                                TextStyle(color: Colors.red, fontSize: 15)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Your Lastname';
                          }
                          return null;
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              updateUser(widget.id, fname, lname);

                              Navigator.pop(context);
                            }
                          },
                          child: const Center(
                            child: Text(
                              'Update',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}
