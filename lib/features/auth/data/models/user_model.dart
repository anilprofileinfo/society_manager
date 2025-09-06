import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String apartmentName;
  final String flatNumber;
  final String role; // 'member' or 'admin'
  final bool isApproved;
  final Timestamp createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.apartmentName,
    required this.flatNumber,
    required this.role,
    required this.isApproved,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      apartmentName: map['apartmentName'] ?? '',
      flatNumber: map['flatNumber'] ?? '',
      role: map['role'] ?? 'member',
      isApproved: map['isApproved'] ?? false,
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'apartmentName': apartmentName,
      'flatNumber': flatNumber,
      'role': role,
      'isApproved': isApproved,
      'createdAt': createdAt,
    };
  }
}
