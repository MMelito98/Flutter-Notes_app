import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/constants/routes.dart';
import 'package:primo/services/auth/auth_exceptions.dart';
import 'package:primo/services/auth/auth_provider.dart';
import 'package:primo/services/auth/auth_service.dart';
import 'package:primo/services/auth/bloc/auth_bloc.dart';
import 'package:primo/services/auth/bloc/auth_event.dart';
import 'package:primo/services/auth/bloc/auth_state.dart';

import '../firebase_options.dart';
import '../utilities/dialogs/error_dialog.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering){
          if(state.exception is WeakPasswordAuthException){
            await showErrorDialog(context, 'Weak Password');
          } else if (state.exception is EmailAlreadyInUseAuthException){
            await showErrorDialog(context, 'Email is already in use');
          } else if (state.exception is EmailAlreadyInUseAuthException){
            await showErrorDialog(context, 'Email is already in use');
          } else if (state.exception is GenericAuthException){
            await showErrorDialog(context, 'Failed to register');
          }
        }
      },
      child: Scaffold(
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
              context.read()<AuthBloc>().add(AuthEventRegister(
                  email: email,
                  password: password,
              ));
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                  const AuthEventLogOut(),
                );
              },
              child: const Text('Already Registered? Login Here!'))
        ]),
      ),
    );
  }
}
