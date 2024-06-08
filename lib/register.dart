import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:studymatchyapp/login.dart';
import 'package:studymatchyapp/services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  late TextEditingController fullnameController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();

  String dropdownvalue = 'Computer Engineering';

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
    return ScaffoldMessenger(
      key: _globalKey,
      child: Scaffold(
        body: Container(
            padding: const EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 0),
                  ),
                  Container(
                      padding: const EdgeInsets.all(50),
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: CircleAvatar(
                        radius: 50, // Adjust the radius as needed
                        backgroundImage:
                            AssetImage('assets/logo.png'), // Your image path
                      )),
                  const Text(
                    'Study Matchy',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 240, 42, 105),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    alignment: Alignment.bottomLeft,
                    child: const Text(
                      'Register!',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(200, 31, 31, 31)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: RichText(
                      text: TextSpan(
                        text: "You already have an account? ",
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 240, 42, 105),
                                fontWeight: FontWeight.w600),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const LoginPage())));
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(82, 240, 42, 105),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: fullnameController,
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
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(82, 240, 42, 105),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            labelText: 'Email',
                            border: InputBorder.none,
                            labelStyle: TextStyle(color: Colors.black)),
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
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Password',
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
                          });
                        },
                        focusColor: Colors.red,
                        underline: const SizedBox(),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 240, 42, 105),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextButton(
                            onPressed: () {
                              Services()
                                  .signUp(
                                      fullnameController.text,
                                      emailController.text,
                                      passwordController.text,
                                      dropdownvalue)
                                  .then((value) {
                                var snackBar = const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text('Success Create Account'));
                                _globalKey.currentState?.showSnackBar(snackBar);
                              }).catchError((error) {
                                var snackBar = const SnackBar(
                                    content: Text('Invalid Credentials'));
                                _globalKey.currentState?.showSnackBar(snackBar);
                              });
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(color: Colors.white),
                            ))),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
