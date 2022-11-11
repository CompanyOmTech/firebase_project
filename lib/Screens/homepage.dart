import 'dart:io';
import 'package:firebase_app/Screens/addpage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'listpage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? file;

  final picker = ImagePicker();

  Future pickImage() async {
    // final pickedFile = await picker.getImage(source: ImageSource.camera);
    XFile? Xfile = await ImagePicker().pickImage(source: ImageSource.gallery);
    file = File(Xfile!.path);
    setState(() {
      file = File(Xfile.path);
    });
  }

  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo App'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPage(),
                ),
              );
            },
            child: const Center(
              child: Text(
                'Add',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    imageUrl == null
                        ? const CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6fVwye3lemzMUkPlZv0ZLx4A9oHz1EJZpLlwyfu4&s',
                            ),
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(imageUrl!),
                          ),
                    Positioned(
                      top: 60,
                      left: 50,
                      child: IconButton(
                        onPressed: () {
                          uploadImage();
                        },
                        icon: const Icon(FontAwesomeIcons.camera),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const ListPage(),
          ],
        ),
      ),
    );
  }

  uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;

    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = (await _picker.getImage(source: ImageSource.gallery))!;
      var file = File(image.path);

      if (image != null) {
        var snapshot =
            await _storage.ref().child('folderName/imageName').putFile(file);

        var downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          imageUrl = downloadUrl;
        });
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }
}
