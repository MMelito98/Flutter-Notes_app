import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:primo/constants/routes.dart';
import 'package:primo/services/auth/auth_service.dart';
import 'package:primo/views/login_views.dart';
import 'package:primo/views/notes/create_update_notes_view.dart';
import 'package:primo/views/notes/notes_view.dart';
import 'package:primo/views/register_view.dart';
import 'package:primo/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute:(context) => const CreateUpdateNotesView(),
        verifyEmailRoute:(context) => const VerifyEmailView(),
        createUpdateNoteRoute:(context) => const NewNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user != null) {
                if (user.isEmailVerified) {
                  devtools.log('Email is Verified');
                  return const CreateUpdateNotesView();
                } else {
                  return const VerifyEmailView();
                }
              } else {
                return LoginView();
              }
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}