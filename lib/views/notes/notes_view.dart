
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:primo/services/auth/auth_provider.dart';
import 'package:primo/services/auth/auth_service.dart';
import 'package:primo/services/crud/notes_service.dart';

import '../../constants/routes.dart';
import '../../enums/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;

  //gets the email
  String get userEmail => AuthService.firebase().currentUser!.email!;

  //open the db in initState
  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();
    super.initState();
  }

  //close the db when the view is disposed
  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.of(context).pushNamed(newNoteRoute);
              },
              icon: const Icon(Icons.add)),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch(value){
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  if (shouldLogout){
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                            (_) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const[
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                ),
              ];
            },
          )
        ],
      ),
      body: FutureBuilder(
         future: _notesService.getOrCreateUser(
             email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.done:
              return StreamBuilder(
                  stream: _notesService.allNotes,
                  builder: (context, snapshot){
                    switch (snapshot.connectionState){
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return const Text('Waiting for all notes');
                      default:
                        return const CircularProgressIndicator();
                    }
                  },
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<bool> showLogoutDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Sign Out'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Logout'),
              ),
            ],

          );
        }
    ).then((value) => value ?? false);
  }


}