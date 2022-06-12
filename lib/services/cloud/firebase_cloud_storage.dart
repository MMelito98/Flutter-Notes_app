import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:primo/services/cloud/cloud_note.dart';
import 'package:primo/services/cloud/cloud_storage_constants.dart';
import 'package:primo/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> deleteNote({required String documentId}) async {
    try{
      await notes.doc(documentId).delete();
    } catch (e){
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
   required String documentId,
   required String text,
}) async {
    try{
      await notes.doc(documentId).update({textFieldName:text});
    } catch (e){
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserIdFieldName == ownerUserId));

  void createNewNotes({required String ownerUserId}) async {
    await notes.add({
      ownerUserId: ownerUserId,
      textFieldName: '',
    });
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserId,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) {
                return CloudNote(
                    documentId: doc.id,
                    ownerUserIdFieldName: doc.data()[ownerUserId] as String,
                    text: doc.data()[textFieldName] as String);
              },
            ),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();

  //factory constuctor
  factory FirebaseCloudStorage() => _shared;
}
