class UserEntity {
  final String id;
  final String name;
  final String phone;
  final String apartmentName;
  final String flatNumber;
  final String role;
  final bool isApproved;
  final DateTime createdAt;

  UserEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.apartmentName,
    required this.flatNumber,
    required this.role,
    required this.isApproved,
    required this.createdAt,
  });
}
