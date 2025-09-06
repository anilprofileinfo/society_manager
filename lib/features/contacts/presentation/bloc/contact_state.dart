part of 'contact_bloc.dart';

abstract class ContactState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ContactLoading extends ContactState {}
class ContactLoaded extends ContactState {
  final List<ContactModel> contacts;
  ContactLoaded(this.contacts);
  @override
  List<Object?> get props => [contacts];
}
class ContactError extends ContactState {
  final String message;
  ContactError(this.message);
  @override
  List<Object?> get props => [message];
}
