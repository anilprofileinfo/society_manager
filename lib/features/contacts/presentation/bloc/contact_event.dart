part of 'contact_bloc.dart';

abstract class ContactEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchContacts extends ContactEvent {}
class AddContact extends ContactEvent {
  final ContactModel contact;
  AddContact(this.contact);
  @override
  List<Object?> get props => [contact];
}
class DeleteContact extends ContactEvent {
  final String id;
  DeleteContact(this.id);
  @override
  List<Object?> get props => [id];
}
class UpdateContact extends ContactEvent {
  final ContactModel contact;
  UpdateContact(this.contact);
  @override
  List<Object?> get props => [contact];
}
