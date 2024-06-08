import 'package:flutter/material.dart';
import 'package:studymatchyapp/login.dart';
import 'package:studymatchyapp/messages.dart';
import 'package:studymatchyapp/profile.dart';
import 'package:studymatchyapp/welcome.dart';

void main() {
  runApp(HomePage());
}

// ignore: use_key_in_widget_constructors, must_be_immutable, camel_case_types
class HomePage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _HomePage createState() => _HomePage();
}

// ignore: camel_case_types
class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: MainAppwidget());
  }
}

// ignore: camel_case_types
class MainAppwidget extends StatefulWidget {
  const MainAppwidget({super.key});

  @override
  MainAppwidgetfooter createState() => MainAppwidgetfooter();
}

class MainAppwidgetfooter extends State<MainAppwidget> {
  int selectedindex = 0;

  static const List widgetoption = [
    WelcomePage(),
    MessagesPage(),
    ProfilePage(),
  ];

  void onitemtapped(int index) {
    setState(() {
      selectedindex = index;
    });
    if (selectedindex == 3) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: ((context) => const LoginPage())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade200,
      body: Center(
        child: widgetoption.elementAt(selectedindex),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SizedBox(
          child: BottomNavigationBar(
            unselectedItemColor: const Color.fromARGB(255, 240, 42, 105),
            selectedItemColor: const Color.fromARGB(255, 240, 42, 105),
            selectedFontSize: 15,
            unselectedFontSize: 15,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),

            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 30,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.sms,
                  size: 30,
                ),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  size: 30,
                ),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.logout,
                  size: 30,
                ),
                label: 'Logout',
              ),
            ],
            currentIndex: selectedindex,
            type: BottomNavigationBarType.fixed,
            onTap: onitemtapped,
            backgroundColor: Colors
                .transparent, // Set to transparent to see the BottomAppBar color
            elevation: 0, // Remove top shadow color
          ),
        ),
      ),
    );
  }
}
