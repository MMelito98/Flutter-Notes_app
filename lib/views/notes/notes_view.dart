import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:primo/services/auth/auth_provider.dart';
import 'package:primo/services/auth/auth_service.dart';
import 'package:primo/services/cloud/cloud_note.dart';
import 'package:primo/services/cloud/firebase_cloud_storage.dart';
import 'package:primo/services/crud/notes_service.dart';
import 'package:primo/utilities/dialogs/logout_dialog.dart';
import 'package:primo/views/notes/notes_list_view.dart';

import '../../constants/routes.dart';
import '../../enums/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() =>
      _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;

  //gets the email
  String get userId => AuthService.firebase().currentUser!.id;

  //open the db in initState
  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
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
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData){
                final allNotes = snapshot.data as
                Iterable<CloudNote>;
                return NotesListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _notesService
                        .deleteNote(documentId: note.documentId,);
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
      ),
    );
  }
}