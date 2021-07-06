import 'package:cloud_firestore/cloud_firestore.dart';

class RemoteRepository {

  Future<DocumentSnapshot> getDocument(String collection, String documentId) {
    return _getCollection(collection).doc(documentId).get();
  }

  CollectionReference _getCollection(String collection) {
    return FirebaseFirestore.instance.collection(collection);
  }
}