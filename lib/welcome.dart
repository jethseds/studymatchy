import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studymatchyapp/services.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WelcomePage createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {
  final PageController _pageController = PageController();

  // ignore: non_constant_identifier_names
  String receiver_uid = "";
  // ignore: non_constant_identifier_names
  String sender_uid = "";
  String category = "";
  List<String> combinedUids = [];

  @override
  void initState() {
    super.initState();
    // Fetch data based on the provided UID when the widget initializes
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('friends')
            .where('sender_uid', isEqualTo: user.uid)
            .get();
        QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
            .collection('friends')
            .where('receiver_uid', isEqualTo: user.uid)
            .get();

        if (querySnapshot.docs.isNotEmpty || querySnapshot2.docs.isNotEmpty) {
          for (var doc in querySnapshot.docs) {
            var userData = doc.data() as Map<String, dynamic>;
            if (userData.containsKey('receiver_uid') &&
                userData['receiver_uid'] != null) {
              setState(() {
                combinedUids.add(userData['receiver_uid']);
              });
            }
          }

          querySnapshot2.docs.forEach((doc) {
            var userData = doc.data() as Map<String, dynamic>;
            if (userData.containsKey('sender_uid') &&
                userData['sender_uid'] != null) {
              setState(() {
                combinedUids.add(userData['sender_uid']);
              });
            }
          });

          setState(() {
            combinedUids.add(user.uid);
          });

          print('Combined UIDs: $combinedUids');
        } else {
          print('No matching documents found');
        }

        QuerySnapshot querySnapshot3 = await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: user.uid)
            .get();

        if (querySnapshot3.docs.isNotEmpty) {
          var userData =
              querySnapshot3.docs.first.data() as Map<String, dynamic>?;

          if (userData != null) {
            setState(() {
              category = userData['category'] ?? '';
            });
          } else {}
        } else {}
      } else {
        print('User is not logged in');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Stream<List<DocumentSnapshot>> getFilteredUsers() async* {
    var user = FirebaseAuth.instance.currentUser;

    var usersQuery = FirebaseFirestore.instance.collection('users').snapshots();

    await for (var snapshot in usersQuery) {
      var allDocs = snapshot.docs;

      // Filter the documents client-side
      var filteredDocs = allDocs.where((doc) {
        var uid = doc['uid'];
        var userCategory = doc['category'];
        return !combinedUids.contains(uid) &&
            uid != user!.uid &&
            userCategory == category;
      }).toList();

      yield filteredDocs;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: getFilteredUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data ?? [];
            data.shuffle(Random());

            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: data.length,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {});
                    },
                    itemBuilder: (context, index) {
                      final userDoc = data[index];
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 240, 42, 105),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: userDoc['images'] != ''
                                    ? Image.network(
                                        userDoc['images'],
                                        fit: BoxFit.cover,
                                      )
                                    : const Image(
                                        image: AssetImage('assets/profile.png'),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  userDoc['fullname'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  userDoc['category'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            _pageController.nextPage(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            );
                                          },
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FaIcon(
                                                // ignore: deprecated_member_use
                                                FontAwesomeIcons.times,
                                                color: Colors.redAccent,
                                                size: 50,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: const BoxDecoration(
                                          color: Colors.blueAccent,
                                          shape: BoxShape.circle,
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            Services().Friends(
                                                user!.uid, userDoc['uid']);
                                            _pageController.nextPage(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            );
                                          },
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FaIcon(
                                                FontAwesomeIcons.userPlus,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
