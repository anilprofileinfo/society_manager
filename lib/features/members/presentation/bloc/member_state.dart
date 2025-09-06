part of 'member_bloc.dart';

abstract class MemberState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MemberLoading extends MemberState {}
class MemberLoaded extends MemberState {
  final List<UserModel> members;
  MemberLoaded(this.members);
  @override
  List<Object?> get props => [members];
}
class MemberError extends MemberState {
  final String message;
  MemberError(this.message);
  @override
  List<Object?> get props => [message];
}
