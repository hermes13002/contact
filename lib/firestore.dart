import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // getting collection of contacts details
  final CollectionReference contacts = FirebaseFirestore.instance.collection('contacts_details');

  // following the crud format
  // Create: add new contact
  Future<void> addContact(String name, String phNum, String email){
    return contacts.add({
      'name': name,
      'phone_number': phNum,
      'email': email,
      'timestamp': Timestamp.now()
    });
  }

  // Read: get contacts from database
  Stream<QuerySnapshot> getContactStream(){
    final contactsStream = contacts.orderBy('timestamp', descending: true).snapshots();
    return contactsStream;
  }

  // Update: update contacts given a doc ID
  Future<void> updateContact(String docID, String newName, String newphNum, String newEmail){
    return contacts.doc(docID).update({
      'name': newName,
      'phne_number': newphNum,
      'email': newEmail,
      'timestamp': Timestamp.now()
    });
  }

  // Delete: delete contacts given a doc ID
  Future<void> deleteContact(String docID){
    return contacts.doc(docID).delete();
  }
}
