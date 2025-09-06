import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/contact_model.dart';
import '../../data/repositories/contact_repository.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepository repository;
  ContactBloc({required this.repository}) : super(ContactLoading()) {
    on<FetchContacts>(_onFetchContacts);
    on<AddContact>(_onAddContact);
    on<DeleteContact>(_onDeleteContact);
    on<UpdateContact>(_onUpdateContact);
  }

  Future<void> _onFetchContacts(FetchContacts event, Emitter<ContactState> emit) async {
    emit(ContactLoading());
    try {
      final contacts = await repository.getContacts();
      emit(ContactLoaded(contacts));
    } catch (e) {
      emit(ContactError('Failed to fetch contacts'));
    }
  }

  Future<void> _onAddContact(AddContact event, Emitter<ContactState> emit) async {
    try {
      await repository.addContact(event.contact);
      add(FetchContacts());
    } catch (e) {
      emit(ContactError('Failed to add contact'));
    }
  }

  Future<void> _onDeleteContact(DeleteContact event, Emitter<ContactState> emit) async {
    try {
      await repository.deleteContact(event.id);
      add(FetchContacts());
    } catch (e) {
      emit(ContactError('Failed to delete contact'));
    }
  }

  Future<void> _onUpdateContact(UpdateContact event, Emitter<ContactState> emit) async {
    try {
      await repository.updateContact(event.contact);
      add(FetchContacts());
    } catch (e) {
      emit(ContactError('Failed to update contact'));
    }
  }
}
