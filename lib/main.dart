import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/constants/routes.dart';
import 'package:primo/helpers/loading/loading_screen.dart';
import 'package:primo/services/auth/bloc/auth_bloc.dart';
import 'package:primo/services/auth/bloc/auth_event.dart';
import 'package:primo/services/auth/bloc/auth_state.dart';
import 'package:primo/services/auth/firebase_auth_provider.dart';
import 'package:primo/views/forgot_password_view.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuthProvider()),
          child: const HomePage(),
      ),
      routes: {
        createUpdateNoteRoute:(context) =>
          const CreateUpdateNoteView(),
      },

    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state){
        if(state.isLoading){
          LoadingScreen().show(
              context: context,
              text: state.loadingText ?? 'Please wait a moment',
          );
        } else{
          LoadingScreen().hide();
        }
      },
      builder: (context, state){
      if(state is AuthStateLoggedIn){
        return const NotesView();
      } else if (state is AuthStateNeedsVerification) {
        return const VerifyEmailView();
      } else if (state is AuthStateLoggedOut){
        return const LoginView();
      } else if (state is AuthStateForgotPassword){
        return const ForgotPasswordView();
      }else if (state is AuthStateRegistering) {
        return const RegisterView();
      }else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    },);
  }
}