class ContactModel {
  final String id;
  final String name;
  final String role;
  final String phone;

  ContactModel({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
  });

  factory ContactModel.fromMap(Map<String, dynamic> map, String id) {
    return ContactModel(
      id: id,
      name: map['name'] ?? '',
      role: map['role'] ?? '',
      phone: map['phone'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': role,
      'phone': phone,
    };
  }
}
