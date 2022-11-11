import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _fromkey = GlobalKey<FormState>();

  var fname = '';
  var lname = '';

  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  CollectionReference students = FirebaseFirestore.instance.collection('users');
  Future<void> addUser() {
    return students
        .add({'firstname': lname, 'lastname': lname})
        .then((value) => print('User Add'))
        .catchError((erroe) => print('Failed to Add user: $erroe'));
    //  print('User Added');
  }

  cleartext() {
    firstnameController.clear();
    lastnameController.clear();
  }

  // void dispose() {
  //   nameController.dispose();
  //   emailController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add'),
      ),
      body: Form(
        key: _fromkey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                    autofocus: false,
                    decoration: const InputDecoration(
                        labelText: 'Firstname',
                        labelStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(),
                        errorStyle: TextStyle(color: Colors.red, fontSize: 15)),
                    controller: firstnameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter FirstName';
                      }
                      return null;
                    }),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                    autofocus: false,
                    decoration: const InputDecoration(
                        labelText: 'lastname',
                        labelStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(),
                        errorStyle: TextStyle(color: Colors.red, fontSize: 15)),
                    controller: lastnameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter lastname';
                      }
                      return null;
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_fromkey.currentState!.validate()) {
                        setState(
                          () {
                            fname = firstnameController.text;
                            lname = lastnameController.text;
                            addUser();
                            Navigator.pop(context);
                            cleartext();
                          },
                        );
                      }
                    },
                    child: const Center(
                      child: Text('Submit'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      cleartext();
                    },
                    child: const Center(
                      child: Text('Reset'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
