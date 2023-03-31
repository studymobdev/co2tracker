import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/share/loadbar.dart';
import 'package:flutter_application_1/share/const.dart';
import 'package:email_validator/email_validator.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return loading
        ? const LoadBar()
        : Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 19, 123, 180),
                Color.fromARGB(255, 54, 64, 70),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  title: const Text('Forgot Password',
                      style:
                          TextStyle(color: Color.fromARGB(229, 227, 225, 203))),
                ),
                body: SizedBox(
                    width: double.infinity,
                    child: Column(children: [
                      const SizedBox(height: 10),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 50.0),
                          child: Form(
                              key: _formKey,
                              child: Column(children: <Widget>[
                                const SizedBox(height: 20.0),
                                const Text(
                                  'Enter your email to reset your password:',
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(238, 240, 243, 221)),
                                ),
                                const SizedBox(height: 20.0),
                                TextFormField(
                                  controller: emailController,
                                  cursorColor: Colors.white,
                                  decoration: inputTextDecor.copyWith(
                                      hintText: 'Email'),
                                  validator: (email) => email != null &&
                                          !EmailValidator.validate(email)
                                      ? 'Enter an existing email'
                                      : null,
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(50)),
                                  icon: const Icon(Icons.email_outlined),
                                  label: const Text(
                                    'Reset Password',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color:
                                            Color.fromARGB(238, 248, 240, 227)),
                                  ),
                                  onPressed: resetPassword,
                                )
                              ]))),
                    ]))));
  }

  Future resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      const SnackBar(
        content: Text('email has been sent successfully!'),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      SnackBar(
        content: Text(e.message!),
      );
      Navigator.of(context).pop();
    }
  }
}
