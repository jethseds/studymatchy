import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studymatchyapp/services.dart';

void main() {
  runApp(const ProfilePage());
}

// ignore: camel_case_types
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePage createState() => _ProfilePage();
}

// ignore: camel_case_types
class _ProfilePage extends State<ProfilePage> {
  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _uidController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();

  String images = "";

  @override
  void initState() {
    super.initState();
    // Fetch data based on the provided UID when the widget initializes
    fetchData();
  }

  String dropdownvalue = 'Computer Engineering';
  Future<void> fetchData() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: user.uid)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          var userData =
              querySnapshot.docs.first.data() as Map<String, dynamic>?;

          if (userData != null) {
            setState(() {
              _idController.text = querySnapshot.docs.first.id;
              _uidController.text = userData['uid'] ?? '';
              _fullnameController.text = userData['fullname'] ?? '';
              dropdownvalue = userData['category'] ?? '';

              images = userData['images'] ?? '';

              downloadURL = userData['images'] ?? '';

              // Update other controllers for other fields accordingly
            });
          } else {}
        } else {}
      } else {}
      // ignore: empty_catches
    } catch (e) {}
  }

  XFile? image;

  String downloadURL = "";

  Future<void> showImage(ImageSource source) async {
    final img = await ImagePicker().pickImage(source: source);
    setState(() {
      image = img;
    });
    if (img != null) {
      await uploadFirebase(File(img.path));
    }
  }

  Future<void> uploadFirebase(File imageFile) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Schedule the dialog to close after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pop(true);
        });

        return AlertDialog(
          title: const Text('Waiting...'),
          content: const Text("Waiting to Upload Image to firebase"),
        );
      },
    );

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().toIso8601String()}.png');
      final uploadTask = storageRef.putFile(imageFile);
      await uploadTask.whenComplete(() async {
        downloadURL = await storageRef.getDownloadURL();
        setState(() {
          print("Download URL: $downloadURL");
        });
      });
    } catch (e) {
      print("Error during upload: $e");
    }
  }

  // List of items in our dropdown menu
  var items = [
    'Computer Engineering',
    'Tourism',
    'Hospitality Management',
    'BA Communication',
    'Business Management',
    'Information Technology',
    'Computer Science',
    'College',
    'Senior High School',
    'General Education',
    'Hobbies',
    'Interests',
    'School experiences',
    'Anyone',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScaffoldMessenger(
        key: _globalKey,
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        showImage(ImageSource.gallery).then((value) {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(82, 240, 42, 105),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            image != null
                                ? Image.file(
                                    File(image!.path),
                                    width: 70,
                                    height: 70,
                                  )
                                : images != ''
                                    ? Image.network(
                                        images,
                                        width: 70,
                                        height: 70,
                                      )
                                    : const FaIcon(
                                        FontAwesomeIcons.userCircle,
                                        size: 70,
                                      ),
                            const Text(
                              'Profile',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: Container(
                        height: 55,
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(82, 240, 42, 105),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          controller: _fullnameController,
                          decoration: const InputDecoration(
                              labelText: 'Fullname',
                              border: InputBorder.none,
                              labelStyle: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: Container(
                        width: double.infinity,
                        height: 55,
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 5),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(82, 240, 42, 105),
                            borderRadius: BorderRadius.circular(10)),
                        child: DropdownButton(
                          isExpanded: true,
                          value: dropdownvalue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                              print(dropdownvalue);
                            });
                          },
                          focusColor: Colors.red,
                          underline: const SizedBox(),
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 30),
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 240, 42, 105),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SizedBox(
                          child: TextButton(
                            onPressed: () {
                              Services()
                                  .Profile(
                                _uidController.text,
                                _fullnameController.text,
                                downloadURL,
                                dropdownvalue,
                              )
                                  .then((value) {
                                var snackBar = const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text('Success Update Profile'));
                                _globalKey.currentState?.showSnackBar(snackBar);
                              });
                            },
                            child: const Text(
                              'Save',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        )),
                    Container(margin: const EdgeInsets.only(bottom: 20))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
