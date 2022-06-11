import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:primo/services/auth/auth_provider.dart';
import 'package:primo/services/auth/auth_service.dart';
import 'package:primo/services/crud/notes_service.dart';
import 'package:primo/utilities/dialogs/logout_dialog.dart';
import 'package:primo/views/notes/notes_list_view.dart';

import '../../constants/routes.dart';
import '../../enums/menu_action.dart';

class CreateUpdateNotesView extends StatefulWidget {
  const CreateUpdateNotesView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateNotesView> createState() =>
      _CreateUpdateNotesViewState();
}

class _CreateUpdateNotesViewState extends State<CreateUpdateNotesView> {
  late final NotesService _notesService;

  //gets the email
  String get userEmail => AuthService.firebase().currentUser!.email!;

  //open the db in initState
  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.of(context).pushNamed(createUpdateNoteRoute);
              },
              icon: const Icon(Icons.add)),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch(value){
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
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
                        if (snapshot.hasData){
                          final allNotes = snapshot.data as
                            List<DatabaseNote>;
                          return NotesListView(
                              notes: allNotes,
                              onDeleteNote: (note) async {
                                await _notesService
                                    .deleteNote(id: note.id);
                              },
                            onTap: (note)  {
                              Navigator.of(context).pushNamed(
                                  createUpdateNoteRoute,
                                  arguments: note,);
                            },
                          );

                        } else {
                          return const CircularProgressIndicator();
                        }

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
}