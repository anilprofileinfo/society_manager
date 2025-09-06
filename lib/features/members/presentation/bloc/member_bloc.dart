import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:society_manager/features/auth/data/models/user_model.dart';
import 'package:society_manager/features/auth/data/repositories/user_repository.dart';

part 'member_event.dart';
part 'member_state.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  final UserRepository userRepository;
  MemberBloc({required this.userRepository}) : super(MemberLoading()) {
    on<FetchPendingMembers>(_onFetchPendingMembers);
    on<ApproveMember>(_onApproveMember);
    on<DeleteMember>(_onDeleteMember);
    on<EditMember>(_onEditMember);
    on<FetchApprovedMembers>(_onFetchApprovedMembers);
  }

  Future<void> _onFetchPendingMembers(FetchPendingMembers event, Emitter<MemberState> emit) async {
    emit(MemberLoading());
    try {
      final members = await userRepository.getPendingUsers();
      emit(MemberLoaded(members));
    } catch (e) {
      emit(MemberError('Failed to fetch pending members'));
    }
  }

  Future<void> _onApproveMember(ApproveMember event, Emitter<MemberState> emit) async {
    try {
      await userRepository.approveUser(event.userId);
      add(FetchPendingMembers());
    } catch (e) {
      emit(MemberError('Failed to approve member'));
    }
  }

  Future<void> _onDeleteMember(DeleteMember event, Emitter<MemberState> emit) async {
    try {
      await userRepository.users.doc(event.userId).delete();
      add(FetchPendingMembers());
    } catch (e) {
      emit(MemberError('Failed to delete member'));
    }
  }

  Future<void> _onEditMember(EditMember event, Emitter<MemberState> emit) async {
    try {
      await userRepository.users.doc(event.userId).update({
        'name': event.name,
        'apartmentName': event.apartmentName,
        'flatNumber': event.flatNumber,
        'phone': event.phone,
      });
      add(FetchPendingMembers());
    } catch (e) {
      emit(MemberError('Failed to edit member'));
    }
  }

  Future<void> _onFetchApprovedMembers(FetchApprovedMembers event, Emitter<MemberState> emit) async {
    emit(MemberLoading());
    try {
      final members = await userRepository.getApprovedUsers();
      emit(MemberLoaded(members));
    } catch (e) {
      emit(MemberError('Failed to fetch members'));
    }
  }
}
