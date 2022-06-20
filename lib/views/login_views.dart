import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/constants/routes.dart';
import 'package:primo/services/auth/auth_exceptions.dart';
import 'package:primo/services/auth/auth_service.dart';
import 'package:primo/services/auth/bloc/auth_bloc.dart';
import 'package:primo/services/auth/bloc/auth_event.dart';
import 'package:primo/utilities/dialogs/loading_dialog.dart';
import 'dart:developer' as devtools show log;

import '../services/auth/bloc/auth_state.dart';
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'User Not Found');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong Password');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication error');
          }
        }
      },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
          ),
          body: Column(children: [
            TextField(
              controller: _email,
              decoration: const InputDecoration(hintText: 'Enter your email here'),
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _password,
              decoration:
                  const InputDecoration(hintText: 'Enter your password here'),
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
            ),
            TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;

                  context.read<AuthBloc>().add(AuthEventLogin(
                        email,
                        password,
                      ));
                },
                child: const Text('Login'),
              ),
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                      const AuthEventShouldRegister(),
                  );
                },
                child: const Text('Not Registered Yet? Register Here!')),
          ]),
        ),
    );
  }
}
