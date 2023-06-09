import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/myuser.dart';
import 'package:flutter_application_1/screens/authenticate/authenticate.dart';
import 'package:flutter_application_1/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapSt();
}

class _WrapSt extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<User1?>(context);
    if (users == null || users == "") {
      return const Authenticate();
    } else {
      return HomePage();
    }
  }
}
