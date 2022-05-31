import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:primo/constants/routes.dart';
import 'package:primo/services/auth/auth_exceptions.dart';
import 'package:primo/services/auth/auth_provider.dart';
import 'package:primo/services/auth/auth_service.dart';
import 'package:primo/utilities/show_err_dialog.dart';

import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register'),
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
              await AuthService.firebase().createUser(
                email: email,
                password: password,
              );
              final user = AuthService.firebase().currentUser;
            //  AuthService.firebase().sendEmailVerification()
              await AuthService.firebase().sendEmailVerification();
              Navigator.of(context).pushNamed(verifyEmailRoute);
            } on WeakPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Weak Password',
                );
              } on EmailAlreadyInUseAuthException{
                await showErrorDialog(
                  context,
                  'Email is already in use',
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  'This is an Invalid Email address',
                );
              } on GenericAuthException{
                await showErrorDialog(
                  context,
                  'Failed to Regiser',
                );
              }
            },
          child: const Text('Register'),
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(
                  loginRoute, (route) => false);
            },
            child: const Text('Already Registered? Login Here!'))
      ]),
    );
  }
}
