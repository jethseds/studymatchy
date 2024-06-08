import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studymatchyapp/messages_view.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MessagesPage createState() => _MessagesPage();
}

class _MessagesPage extends State<MessagesPage> {
  String receiver_uid = "";
  String sender_uid = "";
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
          querySnapshot.docs.forEach((doc) {
            var userData = doc.data() as Map<String, dynamic>;
            if (userData.containsKey('receiver_uid') &&
                userData['receiver_uid'] != null &&
                userData['receiver_uid'] != user.uid) {
              setState(() {
                combinedUids.add(userData['receiver_uid']);
              });
            }
          });

          querySnapshot2.docs.forEach((doc) {
            var userData = doc.data() as Map<String, dynamic>;
            if (userData.containsKey('sender_uid') &&
                userData['sender_uid'] != null &&
                userData['sender_uid'] != user.uid) {
              setState(() {
                combinedUids.add(userData['sender_uid']);
              });
            }
          });

          print('Combined UIDs: $combinedUids');
        } else {
          print('No matching documents found');
        }
      } else {
        print('User is not logged in');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 240, 42, 105),
        title: Row(
          children: [
            Text(
              'Messages',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
        leading: null,
      ),
      body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('uid', whereIn: combinedUids)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data == null) {
                      return Center(child: Text('No data available'));
                    }
                    final alldata = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: alldata.length,
                      itemBuilder: (context, index) {
                        final data = alldata[index];

                        return Column(
                          children: [
                            GestureDetector(
                              child: Container(
                                padding: EdgeInsets.all(7),
                                child: ListTile(
                                  leading: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 240, 42, 105),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    data['fullname'],
                                  ),
                                  tileColor: Colors.blue,
                                ),
                              ),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => MessageViewPage(
                                          senderUid: user!.uid,
                                          receiverUid: data['uid'],
                                        ))),
                              ),
                            ),
                            Divider(height: 0),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }
}
