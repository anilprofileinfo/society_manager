import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_manager/features/auth/data/repositories/user_repository.dart';
import '../bloc/member_bloc.dart';

class AdminApprovalScreen extends StatelessWidget {
  const AdminApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MemberBloc(userRepository: UserRepository())..add(FetchPendingMembers()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Pending Member Approvals')),
        body: BlocBuilder<MemberBloc, MemberState>(
          builder: (context, state) {
            if (state is MemberLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MemberLoaded) {
              if (state.members.isEmpty) {
                return const Center(child: Text('No pending members.'));
              }
              return ListView.builder(
                itemCount: state.members.length,
                itemBuilder: (context, index) {
                  final member = state.members[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(member.name),
                      subtitle: Text('${member.apartmentName} - Flat ${member.flatNumber}\n${member.phone}'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          context.read<MemberBloc>().add(ApproveMember(member.id));
                        },
                        child: const Text('Approve'),
                      ),
                    ),
                  );
                },
              );
            } else if (state is MemberError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
