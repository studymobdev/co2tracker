import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/screens/onboarding/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/services/auth.dart';
import 'package:flutter_application_1/models/myuser.dart';
import 'package:flutter_application_1/screens/wrap.dart';

int? itIsView;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  itIsView = prefs.getInt('onBoard');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User1?>.value(
      initialData: null,
      value: Auth().user,
      child: MaterialApp(
        home: itIsView != 0 ? const OnBoardingPage() : const Wrapper(),
        routes: {'/wrapper': (context) => const Wrapper()},
      ),
    );
  }
}
