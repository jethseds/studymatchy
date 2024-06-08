import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Services {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  signUp(
      String fullname, String email, String password, String category) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    String? uid = userCredential.user?.uid;

    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'uid': uid,
      'fullname': fullname,
      'email': email,
      'category': category,
      'images': '',
    });
  }

  Profile(String uid, String fullname, String images, String category) {
    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'uid': uid,
      'fullname': fullname,
      'images': images,
      'category': category
    });
  }

  Friends(String sender_uid, String receiver_uid) {
    FirebaseFirestore.instance
        .collection('friends')
        .doc(sender_uid + receiver_uid)
        .set({
      'sender_uid': sender_uid,
      'receiver_uid': receiver_uid,
    });
  }
}
