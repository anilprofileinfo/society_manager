import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class EventRepository {
  final CollectionReference events = FirebaseFirestore.instance.collection('events');

  Future<List<EventModel>> getEvents() async {
    final query = await events.orderBy('date').get();
    return query.docs.map((doc) => EventModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<void> addEvent(EventModel event) async {
    await events.add(event.toMap());
  }

  Future<void> deleteEvent(String id) async {
    await events.doc(id).delete();
  }

  Future<void> updateEvent(EventModel event) async {
    await events.doc(event.id).update(event.toMap());
  }
}
