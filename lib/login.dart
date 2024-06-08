import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:studymatchyapp/home.dart';
import 'package:studymatchyapp/register.dart';
import 'package:studymatchyapp/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
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
                    margin: const EdgeInsets.only(top: 50),
                  ),
                  Container(
                    padding: const EdgeInsets.all(50),
                    child: const Image(
                      image: AssetImage('assets/logo.png'),
                      width: 200,
                    ),
                  ),
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
                      'Login!',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(200, 31, 31, 31)),
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
                            labelText: 'Email', border: InputBorder.none),
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
                            labelText: 'Password', border: InputBorder.none),
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
                                  .signIn(emailController.text,
                                      passwordController.text)
                                  .then((value) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => HomePage())));
                              }).catchError((error) {
                                var snackBar = const SnackBar(
                                    content: Text('Invalid Credentials'));
                                _globalKey.currentState?.showSnackBar(snackBar);
                              });
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ))),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: RichText(
                      text: TextSpan(
                        text: "You don't have an account? ",
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'Register',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 240, 42, 105),
                                fontWeight: FontWeight.w600),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const RegisterPage())));
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
