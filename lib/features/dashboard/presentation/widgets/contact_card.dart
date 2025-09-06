import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final String name;
  final String role;
  final String phone;
  const ContactCard({super.key, required this.name, required this.role, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.contact_phone),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(role),
        trailing: Text(phone, style: const TextStyle(fontWeight: FontWeight.w500)),
      ),
    );
  }
}
