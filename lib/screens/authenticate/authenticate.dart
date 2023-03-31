import 'package:flutter_application_1/screens/authenticate/register.dart';
import 'package:flutter_application_1/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  int _currentIndex = 0;

  void toggleView() {
    setState(() {
      _currentIndex = _currentIndex == 0 ? 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _currentIndex,
      children: [
        SignIn(toggleView: toggleView),
        Register(toggleView: toggleView),
      ],
    );
  }
}