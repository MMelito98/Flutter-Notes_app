
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:primo/constants/routes.dart';
import 'package:primo/services/auth/auth_exceptions.dart';
import 'package:primo/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log;

import '../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
    @override
    Widget build(BuildContext context) {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(children: [
        TextField(
          controller: _email,
          decoration: const InputDecoration(
              hintText: 'Enter your email here'),
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
        ),
        TextField(
          controller: _password,
          decoration:
              const InputDecoration(
                  hintText: 'Enter your password here'),
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
        ),
        TextButton(
          onPressed: () async {
            final email = _email.text;
            final password = _password.text;

            try {
              await AuthService.firebase().logIn(
                email: email,
                password: password,
              );
              final user = AuthService.firebase().currentUser;
              if (user?.isEmailVerified ?? false) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  notesRoute,
                      (route) => false,
                );
              } else {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  verifyEmailRoute,
                      (route) => false,
                );
              }
            } on UserNotFoundAuthException {
              await showErrorDialog(
                context,
                'User Not Found',
              );
            }  on WrongPasswordAuthException{
                await showErrorDialog(
                    context,
                    'Wrong Password',
                );
            } on GenericAuthException{
              await showErrorDialog(
                  context,
                  'Authentication Error',
              );
            }

          },
          child: const Text('Login'),
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Not Registered Yet? Register Here!')),
      ]),
    );
  }
}
