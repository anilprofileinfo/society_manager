part of 'member_bloc.dart';

abstract class MemberEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPendingMembers extends MemberEvent {}
class ApproveMember extends MemberEvent {
  final String userId;
  ApproveMember(this.userId);
  @override
  List<Object?> get props => [userId];
}
class DeleteMember extends MemberEvent {
  final String userId;
  DeleteMember(this.userId);
  @override
  List<Object?> get props => [userId];
}
class EditMember extends MemberEvent {
  final String userId;
  final String name;
  final String apartmentName;
  final String flatNumber;
  final String phone;
  EditMember({required this.userId, required this.name, required this.apartmentName, required this.flatNumber, required this.phone});
  @override
  List<Object?> get props => [userId, name, apartmentName, flatNumber, phone];
}
class FetchApprovedMembers extends MemberEvent {}
