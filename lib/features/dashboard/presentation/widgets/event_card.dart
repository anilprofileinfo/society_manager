import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String title;
  final DateTime date;
  final String description;
  const EventCard({super.key, required this.title, required this.date, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${date.day}/${date.month}/${date.year}\n$description'),
        isThreeLine: true,
        leading: const Icon(Icons.event),
      ),
    );
  }
}
