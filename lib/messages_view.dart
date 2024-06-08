import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studymatchyapp/home.dart';

// ignore: must_be_immutable
class MessageViewPage extends StatefulWidget {
  final String senderUid;
  final String receiverUid;
  const MessageViewPage(
      {super.key, required this.senderUid, required this.receiverUid});

  @override
  // ignore: library_private_types_in_public_api
  _MessageViewPage createState() => _MessageViewPage();
}

class _MessageViewPage extends State<MessageViewPage> {
  final user = FirebaseAuth.instance.currentUser!;

  final messagesController = TextEditingController();
  final receiverController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sortid = [widget.senderUid, widget.receiverUid];
    sortid.sort();
    String chatroomID = sortid.join("_");
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 240, 42, 105),
            title: Row(
              children: [
                GestureDetector(
                  child: const Icon(
                    Icons.arrow_left,
                    size: 40,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ));
                  },
                ),
                const Text(
                  'Messages',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          body: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height / 1.23,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('messages')
                        .where("code", isEqualTo: chatroomID)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final messages = snapshot.data!.docs;

                        messages.sort((a, b) {
                          DateTime timestampA = a['timestamp'].toDate();
                          DateTime timestampB = b['timestamp'].toDate();
                          return timestampA.compareTo(timestampB);
                        });
                        return ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            final senderUid = message['sender_uid'];
                            DateTime messageTimestamp =
                                message['timestamp'].toDate();

                            bool sender = user.uid == senderUid ? true : false;

                            final colors = user.uid == senderUid
                                ? Colors.blue
                                : Colors.black;

                            return Column(
                              children: [
                                DateChip(
                                    date:
                                        messageTimestamp), // Assuming messageTimestamp is a DateTime
                                BubbleSpecialThree(
                                  text: message['text'],
                                  color: colors,
                                  tail: true,
                                  isSender: sender,
                                  textStyle: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )
                              ],
                            );
                          },
                        );
                      } else {
                        return const Text('NO MESSAGES');
                      }
                    }),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(82, 216, 216, 216),
                ),
                child: Row(
                  children: [
                    if (user.uid == widget.senderUid ||
                        user.uid == widget.receiverUid)
                      Expanded(
                        child: TextField(
                          controller: messagesController,
                          decoration: const InputDecoration(
                              labelText: 'Send...', border: InputBorder.none),
                        ),
                      ),
                    if (user.uid == widget.senderUid ||
                        user.uid == widget.receiverUid)
                      SizedBox(
                        width: 50,
                        child: TextButton(
                          onPressed: () async {
                            final sortid = [
                              widget.senderUid,
                              widget.receiverUid
                            ];
                            sortid.sort();
                            String chatroomID = sortid.join("_");

                            final refcolmessages = FirebaseFirestore.instance
                                .collection('messages');

                            refcolmessages.add({
                              'text': messagesController.text,
                              'code': chatroomID,
                              'sender_uid': widget.senderUid,
                              'receiver_uid': widget.receiverUid,
                              'timestamp': Timestamp.now(),
                            });
                          },
                          child: const Icon(
                            Icons.send,
                            color: Color.fromARGB(255, 240, 42, 105),
                          ),
                        ),
                      )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
