import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/constants/routes.dart';
import 'package:primo/services/auth/bloc/auth_bloc.dart';
import 'package:primo/services/auth/bloc/auth_event.dart';
import 'package:primo/services/auth/bloc/auth_state.dart';
import 'package:primo/services/auth/firebase_auth_provider.dart';
import 'package:primo/views/login_views.dart';
import 'package:primo/views/notes/create_update_notes_view.dart';
import 'package:primo/views/notes/notes_view.dart';
import 'package:primo/views/register_view.dart';
import 'package:primo/views/verify_email_view.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuthProvider()),
          child: const HomePage(),
      ),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute:(context) => const NotesView(),
        verifyEmailRoute:(context) => const VerifyEmailView(),
        createUpdateNoteRoute:(context) => const CreateUpdateNoteView(),
      },

    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state){
      if(state is AuthStateLoggedIn){
        return const NotesView();
      } else if (state is AuthStateNeedsVerification) {
        return const VerifyEmailView();
      } else if (state is AuthStateLoggedOut){
        return const LoginView();
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    },);
  }
}