import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/contact_model.dart';

class ContactRepository {
  final CollectionReference contacts = FirebaseFirestore.instance.collection('contacts');

  Future<List<ContactModel>> getContacts() async {
    final query = await contacts.get();
    return query.docs.map((doc) => ContactModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<void> addContact(ContactModel contact) async {
    await contacts.add(contact.toMap());
  }

  Future<void> deleteContact(String id) async {
    await contacts.doc(id).delete();
  }

  Future<void> updateContact(ContactModel contact) async {
    await contacts.doc(contact.id).update(contact.toMap());
  }
}
