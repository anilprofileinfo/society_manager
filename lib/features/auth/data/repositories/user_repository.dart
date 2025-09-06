import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRepository {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(UserModel user) async {
    await users.doc(user.id).set(user.toMap());
  }

  Future<UserModel?> getUserById(String id) async {
    final doc = await users.doc(id).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Future<void> approveUser(String id) async {
    await users.doc(id).update({'isApproved': true});
  }

  Future<List<UserModel>> getPendingUsers() async {
    final query = await users.where('isApproved', isEqualTo: false).get();
    return query.docs.map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<List<UserModel>> getApprovedUsers() async {
    final query = await users.where('isApproved', isEqualTo: true).get();
    return query.docs.map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }
}
